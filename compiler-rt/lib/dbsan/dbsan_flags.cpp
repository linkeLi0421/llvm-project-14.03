//===-- dbsan_flags.cpp --------------------------------------*- C -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer.
//
// DbSan flag parsing logic.
//===----------------------------------------------------------------------===//

#include "dbsan_flags.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_flag_parser.h"
#include "sanitizer_common/sanitizer_flags.h"

namespace __dbsan {

Flags dbsan_flags_dont_use_directly; // use via flags().

void Flags::SetDefaults() {
#define DBSAN_FLAG(Type, Name, DefaultValue, Description) Name = DefaultValue;
#include "dbsan_flags.inc"
#undef DBSAN_FLAG
}

static void RegisterDbSanFlags(__sanitizer::FlagParser *parser, Flags *f) {
#define DBSAN_FLAG(Type, Name, DefaultValue, Description)                      \
  RegisterFlag(parser, #Name, Description, &f->Name);
#include "dbsan_flags.inc"
#undef DBSAN_FLAG
}

void InitializeFlags() {
  Flags *f = flags();
  f->SetDefaults();

  __sanitizer::FlagParser dbsan_parser;
  RegisterDbSanFlags(&dbsan_parser, f);

  // Override from command line.
  dbsan_parser.ParseStringFromEnv("DBSAN_OPTIONS");
}

} // namespace __dbsan