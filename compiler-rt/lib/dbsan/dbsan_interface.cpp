//===-- dbsan_interface.cpp
//------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of DumbSanitizer (DbSan).
//
//===----------------------------------------------------------------------===//

#include "dbsan_interface.h"
#include "dbsan_rtl.h"

using namespace __dbsan;

void __dbsan_init() { Initialize(); }

void __dbsan_read1(void *addr) { MemoryAccess((uptr)addr, 1, kAccessRead); }

void __dbsan_read2(void *addr) { MemoryAccess((uptr)addr, 2, kAccessRead); }

void __dbsan_read4(void *addr) { MemoryAccess((uptr)addr, 4, kAccessRead); }

void __dbsan_read8(void *addr) { MemoryAccess((uptr)addr, 8, kAccessRead); }

void __dbsan_read16(void *addr) { MemoryAccess((uptr)addr, 16, kAccessRead); }

void __dbsan_write1(void *addr) { MemoryAccess((uptr)addr, 1, kAccessWrite); }

void __dbsan_write2(void *addr) { MemoryAccess((uptr)addr, 2, kAccessWrite); }

void __dbsan_write4(void *addr) { MemoryAccess((uptr)addr, 4, kAccessWrite); }

void __dbsan_write8(void *addr) { MemoryAccess((uptr)addr, 8, kAccessWrite); }

void __dbsan_write16(void *addr) { MemoryAccess((uptr)addr, 16, kAccessWrite); }