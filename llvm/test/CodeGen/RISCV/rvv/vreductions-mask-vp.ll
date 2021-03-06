; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs < %s | FileCheck %s

declare i1 @llvm.vp.reduce.and.nxv1i1(i1, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define signext i1 @vpreduce_and_nxv1i1(i1 signext %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv1i1(i1 %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv1i1(i1, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define signext i1 @vpreduce_or_nxv1i1(i1 signext %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv1i1(i1 %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv1i1(i1, <vscale x 1 x i1>, <vscale x 1 x i1>, i32)

define signext i1 @vpreduce_xor_nxv1i1(i1 signext %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv1i1(i1 %s, <vscale x 1 x i1> %v, <vscale x 1 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv2i1(i1, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define signext i1 @vpreduce_and_nxv2i1(i1 signext %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv2i1(i1 %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv2i1(i1, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define signext i1 @vpreduce_or_nxv2i1(i1 signext %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv2i1(i1 %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv2i1(i1, <vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define signext i1 @vpreduce_xor_nxv2i1(i1 signext %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv2i1(i1 %s, <vscale x 2 x i1> %v, <vscale x 2 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv4i1(i1, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define signext i1 @vpreduce_and_nxv4i1(i1 signext %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv4i1(i1 %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv4i1(i1, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define signext i1 @vpreduce_or_nxv4i1(i1 signext %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv4i1(i1 %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv4i1(i1, <vscale x 4 x i1>, <vscale x 4 x i1>, i32)

define signext i1 @vpreduce_xor_nxv4i1(i1 signext %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv4i1(i1 %s, <vscale x 4 x i1> %v, <vscale x 4 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv8i1(i1, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define signext i1 @vpreduce_and_nxv8i1(i1 signext %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv8i1(i1 %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv8i1(i1, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define signext i1 @vpreduce_or_nxv8i1(i1 signext %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv8i1(i1 %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv8i1(i1, <vscale x 8 x i1>, <vscale x 8 x i1>, i32)

define signext i1 @vpreduce_xor_nxv8i1(i1 signext %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m1, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv8i1(i1 %s, <vscale x 8 x i1> %v, <vscale x 8 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv16i1(i1, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define signext i1 @vpreduce_and_nxv16i1(i1 signext %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv16i1(i1 %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv16i1(i1, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define signext i1 @vpreduce_or_nxv16i1(i1 signext %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv16i1(i1 %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv16i1(i1, <vscale x 16 x i1>, <vscale x 16 x i1>, i32)

define signext i1 @vpreduce_xor_nxv16i1(i1 signext %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv16i1(i1 %s, <vscale x 16 x i1> %v, <vscale x 16 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv32i1(i1, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define signext i1 @vpreduce_and_nxv32i1(i1 signext %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv32i1(i1 %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv32i1(i1, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define signext i1 @vpreduce_or_nxv32i1(i1 signext %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv32i1(i1 %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv32i1(i1, <vscale x 32 x i1>, <vscale x 32 x i1>, i32)

define signext i1 @vpreduce_xor_nxv32i1(i1 signext %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv32i1(i1 %s, <vscale x 32 x i1> %v, <vscale x 32 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv40i1(i1, <vscale x 40 x i1>, <vscale x 40 x i1>, i32)

define signext i1 @vpreduce_or_nxv40i1(i1 signext %s, <vscale x 40 x i1> %v, <vscale x 40 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv40i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv40i1(i1 %s, <vscale x 40 x i1> %v, <vscale x 40 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.and.nxv64i1(i1, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define signext i1 @vpreduce_and_nxv64i1(i1 signext %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_and_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a1, e8, m8, ta, mu
; CHECK-NEXT:    vmnand.mm v9, v0, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.and.nxv64i1(i1 %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv64i1(i1, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define signext i1 @vpreduce_or_nxv64i1(i1 signext %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv64i1(i1 %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.xor.nxv64i1(i1, <vscale x 64 x i1>, <vscale x 64 x i1>, i32)

define signext i1 @vpreduce_xor_nxv64i1(i1 signext %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_xor_nxv64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v9, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vcpop.m a1, v9, v0.t
; CHECK-NEXT:    xor a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.xor.nxv64i1(i1 %s, <vscale x 64 x i1> %v, <vscale x 64 x i1> %m, i32 %evl)
  ret i1 %r
}

declare i1 @llvm.vp.reduce.or.nxv128i1(i1, <vscale x 128 x i1>, <vscale x 128 x i1>, i32)

define signext i1 @vpreduce_or_nxv128i1(i1 signext %s, <vscale x 128 x i1> %v, <vscale x 128 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vpreduce_or_nxv128i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 3
; CHECK-NEXT:    vmv1r.v v11, v0
; CHECK-NEXT:    mv a3, a1
; CHECK-NEXT:    bltu a1, a2, .LBB22_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, a2
; CHECK-NEXT:  .LBB22_2:
; CHECK-NEXT:    li a4, 0
; CHECK-NEXT:    vsetvli zero, a3, e8, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v9
; CHECK-NEXT:    vcpop.m a3, v11, v0.t
; CHECK-NEXT:    snez a3, a3
; CHECK-NEXT:    sub a2, a1, a2
; CHECK-NEXT:    or a0, a3, a0
; CHECK-NEXT:    bltu a1, a2, .LBB22_4
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:  .LBB22_4:
; CHECK-NEXT:    vsetvli zero, a4, e8, m8, ta, mu
; CHECK-NEXT:    vmv1r.v v0, v10
; CHECK-NEXT:    vcpop.m a1, v8, v0.t
; CHECK-NEXT:    snez a1, a1
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    neg a0, a0
; CHECK-NEXT:    ret
  %r = call i1 @llvm.vp.reduce.or.nxv128i1(i1 %s, <vscale x 128 x i1> %v, <vscale x 128 x i1> %m, i32 %evl)
  ret i1 %r
}
