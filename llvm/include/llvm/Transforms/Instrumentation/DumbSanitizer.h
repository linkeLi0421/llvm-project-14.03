//===--------- Definition of the DumbSanitizer class --------------*- C
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the dumb sanitizer pass.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_TRANSFORMS_INSTRUMENTATION_DUMBSANITIZER_H
#define LLVM_TRANSFORMS_INSTRUMENTATION_DUMBSANITIZER_H

#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

namespace llvm {
// Insert DumbSanitizer instrumentation
FunctionPass *createDumbSanitizerLegacyPassPass();

// A function pass for dbsan instrumentation.
/// Inserts calls to runtime library functions.
struct DumbSanitizerPass : public PassInfoMixin<DumbSanitizerPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
  static bool isRequired() { return true; }
};

/// A module pass for dbsan instrumentation.
/// Create ctor and init functions.
struct ModuleDumbSanitizerPass : public PassInfoMixin<ModuleDumbSanitizerPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
  static bool isRequired() { return true; }
};

} // namespace llvm

#endif