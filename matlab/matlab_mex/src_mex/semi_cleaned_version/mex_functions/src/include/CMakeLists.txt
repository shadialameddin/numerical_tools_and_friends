# compile openmp mex
set(CPP_FILE cpp_mexapi_version test)

# set up matlab libraries
set(CPP_FILE_NAME ${CPP_FILE}.cpp)
INCLUDE_DIRECTORIES(${MATLAB_INCLUDE_DIR})
add_library(latin++ STATIC ${CPP_FILE_NAME} ${CMAKE_SOURCE_DIR}/Matlabdef.def)

target_link_libraries(latin++ ${MATLAB_LIBRARIES})

SET_TARGET_PROPERTIES(latin++ PROPERTIES SUFFIX .o COMPILE_FLAGS ${OpenMP_CXX_FLAGS} LINK_FLAGS ${OpenMP_CXX_FLAGS})

# target_compile_options(latin++ PUBLIC $<$<CONFIG:RELEASE>:-O3 -DNDEBUG -pthread -lto>)
target_compile_options(latin++ PUBLIC -O3 -DNDEBUG -pthread -Wall)
