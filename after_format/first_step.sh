echo "start with:
https://askubuntu.com/questions/450895/mount-luks-encrypted-hard-drive-at-boot
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
"

cd ~ && rm -rf Documents/ Downloads/ Music/ Pictures/ Public/ Templates/ Videos/

source /etc/os-release

if [ "$ID"=="ubuntu" ]; then
  sudo apt install -y ansible snapd
elif [ "$ID"=="fedora" ]; then
  sudo dnf install -y ansible snapd
  sudo ln -s /var/lib/snapd/snap /snap
else
  echo "Don't know this OS"
fi

cat << EOF | tee deleteme.sh && chmod +x deleteme.sh && ./deleteme.sh && rm deleteme.sh
sudo snap install pycharm-professional --classic
sudo snap install clion --classic
sudo snap install gitkraken --classic
sudo snap install skype --classic
sudo snap install code --classic
sudo snap install docker
sudo snap install vlc
sudo snap install acrordrdc
sudo snap install inkscape
sudo snap install gimp
sudo snap install overleaf
sudo snap install ipe --edge
sudo snap install youtube-dl
sudo snap install datagrip --classic
sudo snap install beekeeper-studio
sudo snap install julia --classic
sudo snap install kubectl --classic
sudo snap install chromium
sudo snap refresh
EOF

cat << EOF | tee ~/.config/autostart/yakuake.desktop
[Desktop Entry]
Type=Application
Exec=yakuake
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=yakuake
Name=yakuake
EOF

cat << EOF | tee ~/.config/autostart/nextcloudignore.sh && chmod a+x ~/.config/autostart/nextcloudignore.sh
cd ~
ls -d .* | sed '/.ssh/d' | sed '/.bash./d' | sed '/.detox./d' | sed '/.hidden/d' | sed '/.profile/d' | sed '/.gitconfig/d' | sed '/.gnupg/d' | sed '/.yapf/d' | sed '/.clang/d' | sed '/.selected_editor/d' | sed '$ a .htaccess' > .sync-exclude.lst
EOF

sudo ansible-playbook -v second_step.yml --extra-vars "user=$USER"
./third_step.sh

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
