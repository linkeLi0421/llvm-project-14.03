#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/GuardUtils.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/AtomicOrdering.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace{
    class aadumper : public FunctionPass {

 	public:
 		static char ID;
        std::string Func_name;
 		aadumper() : FunctionPass(ID) {
 			initializeaadumperPass(*PassRegistry::getPassRegistry());
 		}

        aadumper(std::string func_name) : FunctionPass(ID) {
            initializeaadumperPass(*PassRegistry::getPassRegistry());
            Func_name = func_name;
        }

        bool runOnFunction(Function &F) override{
            std::error_code EC;
            if (F.getName() != Func_name)
                return false;
            raw_ostream *out = new raw_fd_ostream("./tmp_alias", EC);
            auto &AAWP = getAnalysis<AAResultsWrapperPass>();
            AliasSetTracker Tracker(AAWP.getAAResults());
            for (Instruction &I : instructions(F))
                Tracker.add(&I);
            Tracker.print(*out);
            return false;
        }
     
        void getAnalysisUsage(AnalysisUsage &AU) const override {
            AU.setPreservesAll();
            AU.addRequired<AAResultsWrapperPass>();
        }
 	};
}



char aadumper::ID = 0;


INITIALIZE_PASS_BEGIN(aadumper, "aadumper",
                "linke try to dump alias set info.", false, false)
INITIALIZE_PASS_DEPENDENCY(AAResultsWrapperPass)
INITIALIZE_PASS_END(aadumper, "aadumper",
                "linke try to dump alias set info.", false, false)

FunctionPass *llvm::createAAdumperPass(std::string func_name) {
   return new aadumper(func_name);
} 