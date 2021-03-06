; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=newgvn -S | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define i1 @patatino(i8* %blah, i32 %choice) {
; CHECK-LABEL: @patatino(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[FOO:%.*]] = phi i8* [ [[BLAH:%.*]], [[ENTRY:%.*]] ], [ null, [[WHILE_BODY:%.*]] ]
; CHECK-NEXT:    switch i32 [[CHOICE:%.*]], label [[WHILE_BODY]] [
; CHECK-NEXT:    i32 -1, label [[WHILE_END:%.*]]
; CHECK-NEXT:    i32 40, label [[LAND_END:%.*]]
; CHECK-NEXT:    ]
; CHECK:       land.end:
; CHECK-NEXT:    br label [[WHILE_END]]
; CHECK:       while.body:
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       while.end:
; CHECK-NEXT:    store i8 0, i8* [[FOO]], align 1
; CHECK-NEXT:    [[TMP0:%.*]] = load i8, i8* [[BLAH]], align 1
; CHECK-NEXT:    [[LOADED:%.*]] = icmp eq i8 [[TMP0]], 0
; CHECK-NEXT:    store i8 0, i8* [[BLAH]], align 1
; CHECK-NEXT:    ret i1 [[LOADED]]
;
entry:
  br label %while.cond

while.cond:
  %foo = phi i8* [ %blah, %entry ], [ null, %while.body ]
  switch i32 %choice, label %while.body [
  i32 -1, label %while.end
  i32 40, label %land.end
  ]

land.end:
  br label %while.end

while.body:
  br label %while.cond

while.end:
  %foo.lcssa = phi i8* [ %foo, %land.end ], [ %foo, %while.cond ]
;; These two stores will initially be considered equivalent, but then proven not.
;; the second store would previously end up deciding it's equivalent to a previous
;; store, but it was really just finding an optimistic version of itself
;; in the congruence class.
  store i8 0, i8* %foo.lcssa, align 1
  %0 = load i8, i8* %blah, align 1
  %loaded = icmp eq i8 %0, 0
  store i8 0, i8* %blah, align 1
  ret i1 %loaded
}


;; This is an example of a case where the memory states are equivalent solely due to unreachability,
;; but the stores are not equal.
define void @foo(i8* %arg) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = phi i8* [ [[ARG:%.*]], [[BB:%.*]] ], [ null, [[BB2:%.*]] ]
; CHECK-NEXT:    br i1 undef, label [[BB3:%.*]], label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB1]]
; CHECK:       bb3:
; CHECK-NEXT:    store i8 0, i8* [[TMP]], align 1, !g !0
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    br label [[BB6:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    br i1 undef, label [[BB9:%.*]], label [[BB7:%.*]]
; CHECK:       bb7:
; CHECK-NEXT:    switch i8 0, label [[BB6]] [
; CHECK-NEXT:    i8 6, label [[BB8:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb8:
; CHECK-NEXT:    store i8 poison, i8* null, align 1
; CHECK-NEXT:    br label [[BB4]]
; CHECK:       bb9:
; CHECK-NEXT:    store i8 0, i8* [[ARG]], align 1, !g !0
; CHECK-NEXT:    unreachable
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb2, %bb
  %tmp = phi i8* [ %arg, %bb ], [ null, %bb2 ]
  br i1 undef, label %bb3, label %bb2

bb2:                                              ; preds = %bb1
  br label %bb1

bb3:                                              ; preds = %bb1
  store i8 0, i8* %tmp, !g !0
  br label %bb4

bb4:                                              ; preds = %bb8, %bb3
  %tmp5 = phi i8* [ null, %bb8 ], [ %arg, %bb3 ]
  br label %bb6

bb6:                                              ; preds = %bb7, %bb4
  br i1 undef, label %bb9, label %bb7

bb7:                                              ; preds = %bb6
  switch i8 0, label %bb6 [
  i8 6, label %bb8
  ]

bb8:                                              ; preds = %bb7
  store i8 undef, i8* %tmp5, !g !0
  br label %bb4

bb9:                                              ; preds = %bb6
  %tmp10 = phi i8* [ %tmp5, %bb6 ]
  store i8 0, i8* %tmp10, !g !0
  unreachable
}

!0 = !{}
