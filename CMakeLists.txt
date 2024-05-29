cmake_minimum_required(VERSION 3.7.2)

project(h3)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Always make a release build
set(CMAKE_BUILD_TYPE Release)

# Avoid building tooling we won't need for release
# See all options with `cmake -LA` in an `h3/build` directory,
# or at https://h3geo.org/docs/next/core-library/compilation-options/
macro(turn_off option_name)
    set(${option_name} OFF CACHE BOOL "" FORCE)
endmacro()
turn_off(BUILD_ALLOC_TESTS)
turn_off(BUILD_BENCHMARKS)
turn_off(BUILD_FILTERS)
turn_off(BUILD_FUZZERS)
turn_off(BUILD_GENERATORS)
turn_off(BUILD_TESTING)
turn_off(ENABLE_COVERAGE)
turn_off(ENABLE_DOCS)
turn_off(ENABLE_FORMAT)
turn_off(ENABLE_LIBFUZZER)
turn_off(ENABLE_LINTING)

# Build the core library as static
set(BUILD_SHARED_LIBS OFF)
add_subdirectory(src/h3lib)

# Build the rest (other than the core library dependency) as shared
set(BUILD_SHARED_LIBS ON)
add_subdirectory(src/h3)

# Include built h3api.h for Cython API
install(
    FILES
        "${CMAKE_CURRENT_BINARY_DIR}/src/h3lib/src/h3lib/include/h3api.h"
    DESTINATION
        src/h3/_cy)

# Include files from h3-py and h3 C libraries
include(GNUInstallDirs)
install(
    FILES
        "CHANGELOG.md"
        "CMakeLists.txt"
        "LICENSE"
        "readme.md"
        "requirements.in"
    DESTINATION
        "${CMAKE_INSTALL_DATADIR}/h3"
)
install(
    FILES
        "src/h3lib/LICENSE"
        "src/h3lib/README.md"
        "src/h3lib/VERSION"
        "src/h3lib/CMakeLists.txt"
    DESTINATION
        "${CMAKE_INSTALL_DATADIR}/h3lib"
)
