//===-- dbsan_rtl.cpp
//------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer (DbSan).
//
// Main file (entry points) for the DbSan run-time.
//===----------------------------------------------------------------------===//

#include "dbsan_rtl.h"
#include "dbsan_flags.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_placement_new.h"

namespace __dbsan {

static void dbsan_atexit() {
  __sanitizer::Printf(
      "#Most frequently accessed address: %p, access count: %zd\n",
      (void *)ctx->most_frequently_accessed_addr,
      ctx->most_frequently_accessed_count);
}

static char ctx_placeholder[sizeof(Context)] ALIGNED(SANITIZER_CACHE_LINE_SIZE);
Context *ctx;

void Initialize() {
  InitializeFlags();
  if (flags()->print_frequent_access)
    __sanitizer::Atexit(dbsan_atexit);
  ctx = new (ctx_placeholder) Context;
}

ALWAYS_INLINE USED void MemoryAccess(uptr addr, uptr size, AccessType typ) {
  if (flags()->verbose) {
    __sanitizer::Printf("#Memory Access: %p/%zd typ=0x%x\n", (void *)addr, size,
                        static_cast<int>(typ));
  }

  uptr access_count = 0;
  switch (size) {
  case 1:
    ctx->rw1_count[addr];
    access_count = ctx->rw1_count[addr];
    break;
  case 2:
    ctx->rw2_count[addr];
    access_count = ctx->rw2_count[addr];
    break;
  case 4:
    ctx->rw4_count[addr];
    access_count = ctx->rw4_count[addr];
    break;
  case 8:
    ctx->rw8_count[addr];
    access_count = ctx->rw8_count[addr];
    break;
  case 16:
    ctx->rw16_count[addr];
    access_count = ctx->rw16_count[addr];
    break;
  default:
    break;
  }

  if (access_count > ctx->most_frequently_accessed_count) {
    ctx->most_frequently_accessed_count = access_count;
    ctx->most_frequently_accessed_addr = addr;
  }
}

} // namespace __dbsan