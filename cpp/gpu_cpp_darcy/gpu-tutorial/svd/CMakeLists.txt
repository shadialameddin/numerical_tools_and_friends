
cmake_minimum_required(VERSION 3.9)

project(svd_test LANGUAGES CUDA CXX)

# set(CUDA_HOST_COMPILER /usr/bin/cuda-g++)
# message(${CUDA_HOST_COMPILER})

# -DCMAKE_CUDA_HOST_COMPILER=/usr/bin/cuda-g++

find_package(CUDA)

add_executable(svd_qr_test svd_qr.cu)
target_link_libraries(svd_qr_test PUBLIC ${CUDA_cublas_LIBRARY} ${CUDA_curand_LIBRARY} ${CUDA_cusolver_LIBRARY})

add_executable(svd_jacobi_test svd_jacobi.cu)
target_link_libraries(svd_jacobi_test PUBLIC ${CUDA_cublas_LIBRARY} ${CUDA_curand_LIBRARY} ${CUDA_cusolver_LIBRARY})
