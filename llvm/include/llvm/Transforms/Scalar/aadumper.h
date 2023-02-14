//===- llvm/include/llvm/Transforms/Scalar/aadumper.h ----------*- C++ -*-===//

#ifndef LLVM_TRANSFORMS_UTILS_IRDumper_H
#define LLVM_TRANSFORMS_UTILS_IRDUmper_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class Function;
class aadumperPass : public PassInfoMixin<aadumperPass> {
private:
    std::string PassName;
public:
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};
}

#endif