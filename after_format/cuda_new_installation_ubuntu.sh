ldconfig -p | grep cuda
# export CUDA_ROOT=<cuda_path>/bin/
# export LD_LIBRARY_PATH=<cuda_path>/lib64/
ldconfig -p | grep libcupti


# grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep :deb
# apt-mark showmanual
# sudo xargs -a pkgs.txt apt install
cat << EOF | sudo tee /etc/apt/sources.list.d/shadi.list
deb http://ppa.launchpad.net/linuxuprising/apps/ubuntu bionic main
deb http://ppa.launchpad.net/nextcloud-devs/client/ubuntu bionic main
EOF
cat << EOF | sudo tee /etc/apt/sources.list.d/cuda.list
deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /
deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /
EOF
# deb http://ppa.launchpad.net/graphics-drivers/ppa/ubuntu bionic main

################################################## GPU
# geforce 10ser gtx 1050 Pascal architecture
# sudo apt remove cuda* nvidia* --purge
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions
# **winner** https://www.tensorflow.org/install/gpu then sudo apt install cuda && sudo apt upgrade
# https://www.pugetsystems.com/labs/hpc/How-To-Install-CUDA-10-1-on-Ubuntu-19-04-1405/#Step2)GettheNVIDIAdriverinstalled
# https://tech.amikelive.com/node-859/installing-cuda-toolkit-9-2-on-ubuntu-16-04-fresh-install-install-by-removing-older-version-install-and-retain-old-version/

# driver & cuda tool kit -> /usr/local/cuda/
su -
cat << EOF > /etc/profile.d/cuda.sh
export PATH=$PATH:/usr/local/cuda/bin
export CUDADIR=/usr/local/cuda
EOF
source /etc/profile.d/cuda.sh
cat << EOF > /etc/ld.so.conf.d/cuda.conf
/usr/local/cuda/lib64
/usr/local/cuda/extras/CUPTI/lib64
/opt/nvidia/nsight-systems/2019.5.2/target-linux-x64/libcupti.so.10.2
EOF
sudo ldconfig #LD_LIBRARY_PATH

nvidia-smi | grep "Driver Version" | awk '{print $6}'
nvcc --version | grep "release" | awk '{print $6}' | cut -c2-

cp -r /usr/local/cuda/samples/ ~/samples
cd ~/samples && make -j4
cd bin
nvprof ./BiCGStab
nvprof ./deviceQuery

echo $CUDADIR
ldconfig -p | grep cuda
ldconfig -p | grep libcupti
# nvcc Cuda compilation tools, release 10.2, V10.2.89
# nvprof Release version 10.2.89 (21)
# NVIDIA-SMI 440.64.00    Driver Version: 440.64.00    CUDA Version: 10.2
# (sa_env) alameddin@shadiplex:~$ cat /etc/profile.d/cuda.sh
# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/cuda/bin
# export CUDADIR=/usr/local/cuda
# (sa_env) alameddin@shadiplex:~$ sudo cat /etc/ld.so.conf.d/cuda-10-1.conf
# /usr/local/cuda-10.1/targets/x86_64-linux/lib
# /usr/local/cuda/lib64
# /usr/local/cuda/extras/CUPTI/lib64
# /opt/nvidia/nsight-systems/2019.5.2/target-linux-x64
# (sa_env) alameddin@shadiplex:~$ sudo cat /etc/ld.so.conf.d/cuda-10-2.conf
# /usr/local/cuda-10.2/targets/x86_64-linux/lib
