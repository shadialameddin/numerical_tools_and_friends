
cmake_minimum_required(VERSION 3.12)

project(test LANGUAGES CXX)

find_package(OpenCL REQUIRED)
find_package(ViennaCL CONFIG)
find_package(Eigen3 REQUIRED)

add_executable(test main.cpp)

target_compile_options(test PUBLIC $<$<CONFIG:RELEASE>:-O3>)
target_include_directories(test PRIVATE ${EIGEN3_INCLUDE_DIR})
target_link_libraries(test PRIVATE OpenCL::OpenCL)

