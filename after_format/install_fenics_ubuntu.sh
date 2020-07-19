sudo apt update
sudo apt install python3 python3-pip

sudo apt install software-properties-common
sudo add-apt-repository ppa:fenics-packages/fenics
sudo apt update
sudo apt install --no-install-recommends fenics
sudo sed -i 's|#if PETSC_VERSION_MAJOR == 3 && PETSC_VERSION_MINOR <= 8 && PETSC_VERSION_RELEASE == 1|#if 1|' /usr/include/dolfin/la/PETScLUSolver.h
pip install --upgrade sympy numpy scipy matplotlib cvxopt multipledispatch pylru toposort pkgconfig ipykernel --user

export packages_folder=/home/alameddin/z_nosync_packages/pyenv/versions/3.6.9/lib/python3.6/site-packages
export packages_folder=/home/alameddin/.local/lib/python3.6/site-packages

git clone https://gitlab.com/RBniCS/RBniCS.git /tmp/RBniCS
cd /tmp/RBniCS && python setup.py install --user&& cd ~
ln -s $packages_folder/RBniCS*egg/rbnics $packages_folder/
wget https://gitlab.com/RBniCS/RBniCS-jupyter/-/raw/master/docker/rbnics.patch -P /tmp/
cd $packages_folder/rbnics && patch -p2 < /tmp/rbnics.patch && cd ~

pyenv virtualenv --system-site-packages fenics
python3 -m venv z_nosync_packages/pyenv/versions/fenics2
pip install scikit-image

python -c 'from dolfin import *; from rbnics import *; import rbnics.utils.config; assert "dolfin" in rbnics.utils.config.config.get("backends", "required backends")'

# on jupyter
# include ! at the beginning of each line other than export
# export -> %env
# python -> separate lines

# https://en.wikiversity.org/wiki/User:Egm6936.s11/FENICS/Installation
# https://fenics.readthedocs.io/en/latest/installation.html

################################ dependencies
dolfin-bin dolfin-doc fenics libamd2 libarpack2-dev libbtf1 libcamd2 libccolamd2 libcholmod3 libcxsparse3 libdolfin-dev libdolfin2019.1 libfftw3-mpi-dev libfftw3-mpi3 libgraphblas1 libhdf5-mpi-dev
libhdf5-openmpi-dev libhypre-2.13.0 libhypre-dev libklu1 libldl2 libmetis5 libmshr-dev libmshr2019.1 libmumps-5.1.2 libmumps-dev libparpack2 libparpack2-dev libpetsc3.7.7 libpetsc3.7.7-dev
libproj-dev libptscotch-6.0 libptscotch-dev librbio2 libscalapack-mpi-dev libscalapack-openmpi-dev libscalapack-openmpi2.0 libscotch-6.0 libscotch-dev libslepc3.7.4 libslepc3.7.4-dev libspooles-dev
libspooles2.2 libspqr2 libsuitesparse-dev libsuperlu-dev libsuperlu-dist5 libumfpack5 pybind11-dev python-ufl-doc
python3-dijitso python3-dolfin python3-ffc python3-fiat python3-mpi4py python3-mpmath python3-mshr python3-petsc4py python3-pkgconfig python3-ply python3-pybind11 python3-slepc4py python3-sympy python3-ufl
