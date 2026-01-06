cmake_minimum_required(VERSION 3.15)
project(mahf_core_portable LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Portable library (for unit tests and CI)
add_library(mahf_portable STATIC
    src/mahf_portable.c
)

target_include_directories(mahf_portable PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

option(BUILD_TESTS "Build unit tests" ON)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
