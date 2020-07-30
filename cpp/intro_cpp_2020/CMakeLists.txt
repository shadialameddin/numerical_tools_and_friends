cmake_minimum_required(VERSION 3.16)
project(intro_cpp_2020)

set(CMAKE_CXX_STANDARD 20)
add_executable(intro_cpp_2020_1 1st_functions_and_variables.cpp)
add_executable(intro_cpp_2020_2 2nd_loops_and_conditions.cpp)
add_executable(intro_cpp_2020_3 3rd_classes.cpp)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()
target_link_libraries(intro_cpp_2020_1 ${CONAN_LIBS})
target_link_libraries(intro_cpp_2020_2 ${CONAN_LIBS})
target_link_libraries(intro_cpp_2020_3 ${CONAN_LIBS})

#fmt
#find_package(fmt REQUIRED)
#target_link_libraries(intro_cpp_2020 fmt::fmt)


