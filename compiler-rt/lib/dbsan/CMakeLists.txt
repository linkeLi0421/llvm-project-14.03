include_directories(..)

# Runtime library sources and build flags.
set(DBSAN_RTL_SOURCES
  dbsan_flags.cpp
  dbsan_interface.cpp
  dbsan_rtl.cpp
  )

set(DBSAN_RTL_HEADERS
  dbsan_flags.h
  dbsan_interface.h
  dbsan_rtl.h
  )

set(DBSAN_COMMON_CFLAGS ${SANITIZER_COMMON_CFLAGS})
append_rtti_flag(OFF DBSAN_COMMON_CFLAGS)
# Prevent clang from generating libc calls.
append_list_if(COMPILER_RT_HAS_FFREESTANDING_FLAG -ffreestanding DBSAN_COMMON_CFLAGS)

# Too many existing bugs, needs cleanup.
append_list_if(COMPILER_RT_HAS_WNO_FORMAT -Wno-format DBSAN_COMMON_CFLAGS)

# Static runtime library.
add_compiler_rt_component(dbsan)

foreach(arch ${DBSAN_SUPPORTED_ARCH})
  set(DBSAN_CFLAGS ${DBSAN_COMMON_CFLAGS})
  append_list_if(COMPILER_RT_HAS_FPIE_FLAG -fPIE DBSAN_CFLAGS)
  add_compiler_rt_runtime(clang_rt.dbsan
    STATIC
    ARCHS ${arch}
    SOURCES ${DBSAN_RTL_SOURCES}
            $<TARGET_OBJECTS:RTInterception.${arch}>
            $<TARGET_OBJECTS:RTSanitizerCommon.${arch}>
            $<TARGET_OBJECTS:RTSanitizerCommonLibc.${arch}>
            $<TARGET_OBJECTS:RTSanitizerCommonSymbolizer.${arch}>
    ADDITIONAL_HEADERS ${DBSAN_RTL_HEADERS}
    CFLAGS ${DBSAN_CFLAGS}
    PARENT_TARGET dbsan)
  add_sanitizer_rt_symbols(clang_rt.dbsan
    ARCHS ${arch}
    EXTRA dbsan.syms.extra)
  add_dependencies(dbsan
    clang_rt.dbsan-${arch}-symbols)
endforeach()