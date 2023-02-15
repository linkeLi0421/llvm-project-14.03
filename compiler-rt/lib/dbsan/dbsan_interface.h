//===-- dbsan_interface.h ----------------------------------------*- C
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
// The functions declared in this header will be inserted by the instrumentation
// module.
//===----------------------------------------------------------------------===//
#ifndef DBSAN_INTERFACE_H
#define DBSAN_INTERFACE_H

#include <sanitizer_common/sanitizer_internal_defs.h>

// This header should NOT include any other headers.
// All functions in this header are extern "C" and start with __dbsan_.

#ifdef __cplusplus
extern "C" {
#endif

SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_init();

SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_read1(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_read2(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_read4(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_read8(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_read16(void *addr);

SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_write1(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_write2(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_write4(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_write8(void *addr);
SANITIZER_INTERFACE_ATTRIBUTE void __dbsan_write16(void *addr);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // DBSAN_INTERFACE_H