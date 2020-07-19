cmake_minimum_required(VERSION 3.0)

project(latin++)

# set(CMAKE_CXX_STANDARD 17)
add_definitions("-O8 -DNDEBUG -pthread -lto -std=c++17 -march=native -mtune=native -Wall -W") # -Wno-unused-variable 



set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake) # add FindMatlab module

add_definitions(/DMATLAB_MEX_FILE) #define matlab macros
add_definitions(/DMATLAB_DEFAULT_RELEASE)

# Matrix APIs:
# -DMX_COMPAT_32: compatibleArrayDims
# -DMATLAB_DEFAULT_RELEASE=R2017b: largeArrayDims
# -DMATLAB_DEFAULT_RELEASE=R2018a: Interleaved Complex

find_package(Matlab REQUIRED)
find_package(OpenMP REQUIRED)

IF(MATLAB_FOUND AND OPENMP_FOUND)
    message(STATUS "OpenMP Found, OpenMP MEX will be compiled.")
ELSE(MATLAB_FOUND AND OPENMP_FOUND)
    MESSAGE("MATLAB or OpenMP not found...nothing will be built.")
ENDIF(MATLAB_FOUND AND OPENMP_FOUND)

option(ENABLE_NATIVE "Optimise for current architecture" ON)

if (ENABLE_NATIVE)
    add_definitions("-march=native -mtune=native")
endif()

# SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${C_FLAGS}" )
# SET( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${C_FLAGS}" )
# set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall")
# set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall")

add_subdirectory(src)
