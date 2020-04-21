gnome-terminal -- sh -c "nvidia-smi -l 1"

# run two instances on the same GPU after enabling memory_growth in tensorflow_gpu_test.py
CUDA_VISIBLE_DEVICES=0 python tensorflow_gpu_test.py & CUDA_VISIBLE_DEVICES=0 python tensorflow_gpu_test.py

# profile the code to see if it's reasonable to send the data to the GPU
nvprof python tensorflow_gpu_test.py
