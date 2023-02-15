//===-- dbsan_flags.h ---------------------------------------*- C -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer.
//
// DumbSanitizer runtime flags.
//===----------------------------------------------------------------------===//

#ifndef DBSAN_FLAGS_H
#define DBSAN_FLAGS_H

#include "sanitizer_common/sanitizer_flag_parser.h"
#include "sanitizer_common/sanitizer_internal_defs.h"

namespace __dbsan {

struct Flags {
#define DBSAN_FLAG(Type, Name, DefaultValue, Description) Type Name;
#include "dbsan_flags.inc"
#undef DBSAN_FLAG

  void SetDefaults();
};

extern Flags dbsan_flags_dont_use_directly;
inline Flags *flags() { return &dbsan_flags_dont_use_directly; }

void InitializeFlags();

} // namespace __dbsan

#endif // DBSAN_FLAGS_H