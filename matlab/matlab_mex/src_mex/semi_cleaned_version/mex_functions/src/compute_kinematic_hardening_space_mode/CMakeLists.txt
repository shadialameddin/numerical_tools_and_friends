# compile openmp mex
set(CPP_FILE compute_kinematic_hardening_space_mode)

# set up matlab libraries
set(CPP_FILE_NAME ${CPP_FILE}.cpp)
INCLUDE_DIRECTORIES(${MATLAB_INCLUDE_DIR} ../include ../src)
add_library(${CPP_FILE} SHARED ${CPP_FILE_NAME} ${CMAKE_SOURCE_DIR}/Matlabdef.def)

target_link_libraries(${CPP_FILE} ${MATLAB_LIBRARIES} latin++)

# target_compile_options(${CPP_FILE} PUBLIC $<$<CONFIG:RELEASE>:-O3 -DNDEBUG -pthread -lto>)
# -ffast-math

add_dependencies(${CPP_FILE} latin++)

# 32-bit or 64-bit mex
if(WIN32)
  if (CMAKE_CL_64)
      SET_TARGET_PROPERTIES(${CPP_FILE} PROPERTIES SUFFIX .mexw64 COMPILE_FLAGS ${OpenMP_CXX_FLAGS} LINK_FLAGS ${OpenMP_CXX_FLAGS})
  else(CMAKE_CL_64)
      SET_TARGET_PROPERTIES(${CPP_FILE} PROPERTIES SUFFIX .mexw32 COMPILE_FLAGS ${OpenMP_CXX_FLAGS} LINK_FLAGS ${OpenMP_CXX_FLAGS})
  endif(CMAKE_CL_64)
else(WIN32) # linux
  if (CMAKE_SIZEOF_VOID_P MATCHES "8")
      SET_TARGET_PROPERTIES(${CPP_FILE} PROPERTIES SUFFIX .mexa64 PREFIX "" COMPILE_FLAGS ${OpenMP_CXX_FLAGS} LINK_FLAGS ${OpenMP_CXX_FLAGS})
  else(CMAKE_SIZEOF_VOID_P MATCHES "8")
      SET_TARGET_PROPERTIES(${CPP_FILE} PROPERTIES SUFFIX .mexglx PREFIX "" COMPILE_FLAGS ${OpenMP_CXX_FLAGS} LINK_FLAGS ${OpenMP_CXX_FLAGS})
  endif (CMAKE_SIZEOF_VOID_P MATCHES "8")
endif(WIN32)

# install to /bin by default
# install(TARGETS ${CPP_FILE} DESTINATION ./bin)
