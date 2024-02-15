cmake_minimum_required(VERSION 3.10)
project(ffi_dart VERSION 1.0)

# Add your source file
set(SOURCES
    ./logic.cpp
)

# Add your library
add_library(ffi_dart_library SHARED ${SOURCES})