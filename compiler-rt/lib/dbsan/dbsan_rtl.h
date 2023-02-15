//===-- dbsan_rtl.h ----------------------------------------------*- C
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer (DbSan).
//
// Main internal DbSan header file.
//===----------------------------------------------------------------------===//

#ifndef DBSAN_RTL_H
#define DBSAN_RTL_H

#include "sanitizer_common/sanitizer_dense_map.h"
#include "sanitizer_common/sanitizer_internal_defs.h"

namespace __dbsan {

using __sanitizer::uptr;
typedef uptr AccessType;
enum : AccessType {
  kAccessWrite = 0,
  kAccessRead = 1 << 0,
};

struct Context {
  Context()
      : initialized(), most_frequently_accessed_addr(),
        most_frequently_accessed_count(), rw1_count(), rw2_count(), rw4_count(),
        rw8_count(), rw16_count(){};
  bool initialized;
  uptr most_frequently_accessed_addr;
  uptr most_frequently_accessed_count;
  __sanitizer::DenseMap<uptr, uptr> rw1_count;
  __sanitizer::DenseMap<uptr, uptr> rw2_count;
  __sanitizer::DenseMap<uptr, uptr> rw4_count;
  __sanitizer::DenseMap<uptr, uptr> rw8_count;
  __sanitizer::DenseMap<uptr, uptr> rw16_count;
};

extern Context *ctx; // The one and the only global runtime context.

void Initialize();
void MemoryAccess(uptr addr, uptr size, AccessType typ);

} // namespace __dbsan

#endif
