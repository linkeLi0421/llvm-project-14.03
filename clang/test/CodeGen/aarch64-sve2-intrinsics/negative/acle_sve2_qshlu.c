// REQUIRES: aarch64-registered-target

// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -fsyntax-only -verify %s
// RUN: %clang_cc1 -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve2 -fallow-half-arguments-and-returns -fsyntax-only -verify %s

#ifdef SVE_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SVE builtin.
#define SVE_ACLE_FUNC(A1,A2_UNUSED,A3,A4_UNUSED) A1##A3
#else
#define SVE_ACLE_FUNC(A1,A2,A3,A4) A1##A2##A3##A4
#endif

#include <arm_sve.h>

svuint8_t test_svqshlu_n_s8_z(svbool_t pg, svint8_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 7]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s8,_z,)(pg, op1, -1);
}

svuint16_t test_svqshlu_n_s16_z(svbool_t pg, svint16_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 15]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s16,_z,)(pg, op1, -1);
}

svuint32_t test_svqshlu_n_s32_z(svbool_t pg, svint32_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 31]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s32,_z,)(pg, op1, -1);
}

svuint64_t test_svqshlu_n_s64_z(svbool_t pg, svint64_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 63]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s64,_z,)(pg, op1, -1);
}

svuint8_t test_svqshlu_n_s8_m(svbool_t pg, svint8_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 7]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s8,_m,)(pg, op1, -1);
}

svuint16_t test_svqshlu_n_s16_m(svbool_t pg, svint16_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 15]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s16,_m,)(pg, op1, -1);
}

svuint32_t test_svqshlu_n_s32_m(svbool_t pg, svint32_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 31]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s32,_m,)(pg, op1, -1);
}

svuint64_t test_svqshlu_n_s64_m(svbool_t pg, svint64_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 63]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s64,_m,)(pg, op1, -1);
}

svuint8_t test_svqshlu_n_s8_x(svbool_t pg, svint8_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 7]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s8,_x,)(pg, op1, -1);
}

svuint16_t test_svqshlu_n_s16_x(svbool_t pg, svint16_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 15]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s16,_x,)(pg, op1, -1);
}

svuint32_t test_svqshlu_n_s32_x(svbool_t pg, svint32_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 31]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s32,_x,)(pg, op1, -1);
}

svuint64_t test_svqshlu_n_s64_x(svbool_t pg, svint64_t op1)
{
  // expected-error-re@+1 {{argument value {{[0-9]+}} is outside the valid range [0, 63]}}
  return SVE_ACLE_FUNC(svqshlu,_n_s64,_x,)(pg, op1, -1);
}
