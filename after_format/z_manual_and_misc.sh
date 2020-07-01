########################## old setup ############################

# dnf install -y atom @c-development patch mercurial cmake lcov clang clang-tools-extra libomp-devel gcc-c++ openblas-devel MUMPS-devel boost-devel vtk-devel hwloc-devel scotch-devel tbb-devel arpack-devel catch-devel viennacl-devel pocl-devel clpeak clinfo opencl-headers kernel-devel clang-devel metis-devel google-chrome-stable yakuake eigen3-devel thunderbird shotwell pdfshuffler inkscape texlive texlive-scheme-full texstudio meld doxygen libtool make htop poppler-cpp git-lfs texlive-collection-latex paraview kernel-headers dkms doxygen-doxywizard libreoffice detox deja-dup graphviz java-openjdk mediawriter vlc pdfgrep arpack system-config-printer dconf-editor hwloc flex freecad netgen gmsh gazebo ipe xfig openmotif freeimage-devel fftw fftw-devel rocm-runtime rocm-runtime-devel elfutils-libelf-devel perf ktouch libnsl ark python3-tkinter fslint intel-gpu-tools recoll gparted gnome-tweaks vim fbreader uncrustify rc nextcloud nextcloud-client libgnome-keyring seahorse powertop tlp docker docker-compose gimp libxcrypt-compat smesh VirtualBox libXi-devel unison evolution fuse-sshfs octave gnome-shell-extension-topicons-plus npm dnf-automatic nano install moreutils moreutils-parallel

# docker
# sudo dnf install -y grubby && grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0" && reboot
# dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo && dnf install docker-ce && systemctl enable --now docker && groupadd docker && usermod -aG docker alameddin && systemctl status docker

#gpg
# gpg --list-secret-keys --keyid-format LONG
# gpg2 --list-keys --keyid-format LONG
# git config --global gpg.program gpg2
# git config --global user.signingkey ***********
# git config --global commit.gpgsign true
# git config --global gpg.program /usr/bin/gpg2

# ssh
# sudo apt install openssh-server
# sudo systemctl enable ssh
# sudo systemctl start ssh
# sudo systemctl status ssh
# sudo ufw allow ssh




################################## python formatter #############################################
sudo apt install -y yapf
sudo ln -sf /usr/bin/yapf /usr/local/bin/yapf
cat << EOF > ~/.style.yapf
[style]
column_limit = 130
SPLIT_BEFORE_NAMED_ASSIGNS=false
EOF
################################## python versions #############################################
pyenv update
pyenv global 3.7.7
# pyenv global 3.7.7 2.7.10
# pyenv local 2.7.15
# This command creates a .python-version file in your current directory.
# If you have pyenv active in your environment, this file will automatically activate this version for you.
pyenv shell 3.7.7
# some times I had to run this command twice but after exiting the shell everything worked nicely
# to be sure if you're in the right version or environment, run
pyenv versions
which python
pyenv which python
python -V
source ~/.bashrc
################################## python env #############################################
# pyenv virtualenv <python_version> <environment_name>
pyenv virtualenv sa_env
pyenv global sa_env
pyenv activate sa_env
# pyenv virtualenv-delete my_virtual_env
# pyenv virtualenv --system-site-packages blabla
################################## plugins #############################################
# if you face an error while creating a virtualenv with 2.7.10
pip install --upgrade pip
# migrate pip package from a Python version to another
git clone git://github.com/pyenv/pyenv-pip-migrate.git $(pyenv root)/plugins/pyenv-pip-migrate
pyenv migrate 3.8.2 tstenv
# Allow pyenv to guess the python version from the program name e.g. python2 or python3
# git clone git://github.com/concordusapps/pyenv-implict.git ~/.pyenv/plugins/pyenv-implict
################################## update pkgs #############################################
# update all packages
# Update all libraries managed by pip or conda in all environments (pyenv plugin).
# https://github.com/massongit/pyenv-pip-update
# in one environment
# pip freeze | xargs pip install --upgrade
pip list --outdated --format columns| cut -d' ' -f1| sed 1,2d| xargs -n1 pip install --upgrade
python3 -m venv z_nosync_packages/pyenv/versions/blabla
pip list --format columns| awk '{print $1}'|sed 1,2d
pip install -r requirements.txt --upgrade
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
sudo update-alternatives --config python
sudo update-alternatives --set python /usr/bin/python3.6
pyenv migrate system 3.6.9




###############################################################################
