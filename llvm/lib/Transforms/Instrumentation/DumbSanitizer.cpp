//===- DumbSanitizer.cpp - dumb memory access profiler ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer. Memory accesses are instrumented
// to calls to run-time library which increment the access count held in a map.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Instrumentation/DumbSanitizer.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

using namespace llvm;

#define DEBUG_TYPE "dbsan"

const char kDbsanModuleCtorName[] = "dbsan.module_ctor";
const char kDbsanInitName[] = "__dbsan_init";

// Command-line flags.

static cl::opt<bool> ClInstrumentReads("dbsan-instrument-reads",
                                       cl::desc("instrument read instructions"),
                                       cl::Hidden, cl::init(true));

static cl::opt<bool>
    ClInstrumentWrites("dbsan-instrument-writes",
                       cl::desc("instrument write instructions"), cl::Hidden,
                       cl::init(true));

STATISTIC(NumInstrumentedReads, "Number of instrumented reads");
STATISTIC(NumInstrumentedWrites, "Number of instrumented writes");

namespace {

struct InterestingMemoryAccess {
  Value *Addr = nullptr;
  bool IsWrite;
  unsigned Alignment;
  Type *AccessTy;
  uint64_t TypeSize;
};

/// Instrument the code in module to profile memory accesses.
class DumbSanitizer {
public:
  DumbSanitizer(Module &M) { C = &(M.getContext()); }

  bool sanitizeFunction(Function &F);

private:
  void initializeCallbacks(Module &M);
  int getMemoryAccessFuncIndex(uint32_t TypeSize);
  /// If it is an interesting memory access, populate information
  /// about the access and return a InterestingMemoryAccess struct.
  /// Otherwise return None.
  Optional<InterestingMemoryAccess>
  isInterestingMemoryAccess(Instruction *I) const;
  void instrumentMemoryAccess(Instruction *I, const DataLayout &DL,
                              InterestingMemoryAccess &Access);

  LLVMContext *C;
  int LongSize;
  Type *IntptrTy;
  // Accesses sizes are powers of two: 1, 2, 4, 8, 16.
  static const size_t kNumberOfAccessSizes = 5;
  FunctionCallee DbsanRead[kNumberOfAccessSizes];
  FunctionCallee DbsanWrite[kNumberOfAccessSizes];
  Value *DynamicShadowOffset = nullptr;
};

struct DumbSanitizerLegacyPass : public FunctionPass {
  DumbSanitizerLegacyPass() : FunctionPass(ID) {
    initializeDumbSanitizerLegacyPassPass(*PassRegistry::getPassRegistry());
  }
  StringRef getPassName() const override;
  bool doInitialization(Module &M) override;
  bool runOnFunction(Function &F) override;
  static char ID;

private:
  Optional<DumbSanitizer> DbSan;
};

void insertModuleCtor(Module &M) {
  getOrCreateSanitizerCtorAndInitFunctions(
      M, kDbsanModuleCtorName, kDbsanInitName, /*InitArgTypes=*/{},
      /*InitArgs=*/{},
      // This callback is invoked when the functions are created the first
      // time. Hook them into the global ctors list in that case:
      [&](Function *Ctor, FunctionCallee) { appendToGlobalCtors(M, Ctor, 0); });
}

} // end anonymous namespace

PreservedAnalyses DumbSanitizerPass::run(Function &F,
                                         FunctionAnalysisManager &FAM) {
  DumbSanitizer DbSan(*F.getParent());
  if (DbSan.sanitizeFunction(F))
    return PreservedAnalyses::none();
  return PreservedAnalyses::all();
}

PreservedAnalyses ModuleDumbSanitizerPass::run(Module &M,
                                               ModuleAnalysisManager &MAM) {
  insertModuleCtor(M);
  return PreservedAnalyses::none();
}

char DumbSanitizerLegacyPass::ID = 0;
INITIALIZE_PASS_BEGIN(DumbSanitizerLegacyPass, "dbsan",
                      "DumbSanitizer: profile memory accesses.", false, false)
INITIALIZE_PASS_END(DumbSanitizerLegacyPass, "dbsan",
                    "DumbSanitizer: profile memory accesses.", false, false)

StringRef DumbSanitizerLegacyPass::getPassName() const {
  return "DumbSanitizerLegacyPass";
}

bool DumbSanitizerLegacyPass::doInitialization(Module &M) {
  insertModuleCtor(M);
  DbSan.emplace(M);
  return true;
}

bool DumbSanitizerLegacyPass::runOnFunction(Function &F) {
  return DbSan->sanitizeFunction(F);
}

FunctionPass *llvm::createDumbSanitizerLegacyPassPass() {
  return new DumbSanitizerLegacyPass();
}

Optional<InterestingMemoryAccess>
DumbSanitizer::isInterestingMemoryAccess(Instruction *I) const {
  InterestingMemoryAccess Access;

  if (LoadInst *LI = dyn_cast<LoadInst>(I)) {
    if (!ClInstrumentReads)
      return None;
    Access.IsWrite = false;
    Access.AccessTy = LI->getType();
    Access.Alignment = LI->getAlignment();
    Access.Addr = LI->getPointerOperand();
  } else if (StoreInst *SI = dyn_cast<StoreInst>(I)) {
    if (!ClInstrumentWrites)
      return None;
    Access.IsWrite = true;
    Access.AccessTy = SI->getValueOperand()->getType();
    Access.Alignment = SI->getAlignment();
    Access.Addr = SI->getPointerOperand();
  }

  if (!Access.Addr)
    return None;

  // Do not instrument acesses from different address spaces; we cannot deal
  // with them.
  Type *PtrTy = cast<PointerType>(Access.Addr->getType()->getScalarType());
  if (PtrTy->getPointerAddressSpace() != 0)
    return None;

  const DataLayout &DL = I->getModule()->getDataLayout();
  Access.TypeSize = DL.getTypeStoreSizeInBits(Access.AccessTy);
  return Access;
}

void DumbSanitizer::instrumentMemoryAccess(Instruction *I, const DataLayout &DL,
                                           InterestingMemoryAccess &Access) {
  if (Access.IsWrite)
    NumInstrumentedWrites;
  else
    NumInstrumentedReads;

  IRBuilder<> IRB(I);
  int Idx = getMemoryAccessFuncIndex(Access.TypeSize);
  if (Idx < 0)
    return;
  FunctionCallee OnAccessFunc =
      Access.IsWrite ? DbsanWrite[Idx] : DbsanRead[Idx];
  IRB.CreateCall(OnAccessFunc,
                 IRB.CreatePointerCast(Access.Addr, IRB.getInt8PtrTy()));
}

int DumbSanitizer::getMemoryAccessFuncIndex(uint32_t TypeSize) {
  if (TypeSize != 8 && TypeSize != 16 && TypeSize != 32 && TypeSize != 64 &&
      TypeSize != 128) {
    // Ignore all unusual sizes.
    return -1;
  }
  size_t Idx = countTrailingZeros(TypeSize / 8);
  assert(Idx < kNumberOfAccessSizes);
  return Idx;
}

void DumbSanitizer::initializeCallbacks(Module &M) {
  IRBuilder<> IRB(*C);
  AttributeList Attr;
  Attr = Attr.addFnAttribute(M.getContext(), Attribute::NoUnwind);

  for (size_t i = 0; i < kNumberOfAccessSizes; i) {
    const unsigned ByteSize = 1U << i;
    std::string ByteSizeStr = utostr(ByteSize);
    SmallString<32> ReadName("__dbsan_read" + ByteSizeStr);
    DbsanRead[i] = M.getOrInsertFunction(ReadName, Attr, IRB.getVoidTy(),
                                         IRB.getInt8PtrTy());

    SmallString<32> WriteName("__dbsan_write" + ByteSizeStr);
    DbsanWrite[i] = M.getOrInsertFunction(WriteName, Attr, IRB.getVoidTy(),
                                          IRB.getInt8PtrTy());
  }
}

bool DumbSanitizer::sanitizeFunction(Function &F) {
  if (F.getLinkage() == GlobalValue::AvailableExternallyLinkage)
    return false;
  if (F.getName().startswith("__dbsan_"))
    return false;
  if (F.getName() == kDbsanModuleCtorName)
    return false;

  bool FunctionModified = false;
  LLVM_DEBUG(dbgs() << "dbsan instrumenting:\n" << F << "\n");

  initializeCallbacks(*F.getParent());

  SmallVector<Instruction *, 16> LoadsAndStores;
  for (auto &BB : F) {
    for (auto &Inst : BB) {
      if (isa<LoadInst>(Inst) || isa<StoreInst>(Inst))
        LoadsAndStores.push_back(&Inst);
    }
  }

  int NumInstrumented = 0;
  for (auto *Inst : LoadsAndStores) {
    Optional<InterestingMemoryAccess> Access = isInterestingMemoryAccess(Inst);
    if (Access) {
      instrumentMemoryAccess(Inst, F.getParent()->getDataLayout(), *Access);
      NumInstrumented;
    }
  }

  if (NumInstrumented > 0)
    FunctionModified = true;
  LLVM_DEBUG(dbgs() << "dbsan done instrumenting: " << FunctionModified << " "
                    << F << "\n");
  return FunctionModified;
}
