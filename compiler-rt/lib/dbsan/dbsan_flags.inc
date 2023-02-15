//===-- dbsan_flags.inc ------------------------------------------*- C -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// DbSan runtime flags.
//
//===----------------------------------------------------------------------===//
#ifndef DBSAN_FLAG
# error "Define DBSAN_FLAG prior to including this file!"
#endif

// DBSAN_FLAG(Type, Name, DefaultValue, Description)

DBSAN_FLAG(bool, verbose, false, "Print runtime loginfo.")
DBSAN_FLAG(bool, print_frequent_access, false, "Print most frequently access info at exit.")