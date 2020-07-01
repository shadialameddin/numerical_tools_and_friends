sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2

cd /packages
wget https://www.syntevo.com/downloads/smartgit/smartgit-linux-20_1_3.tar.gz
tar -xvf smartgit-linux-20_1_3.tar.gz
cat << EOF | tee /home/$USER/.local/share/applications/smartgit.desktop
[Desktop Entry]
Type=Application
Exec=/packages/smartgit/bin/smartgit.sh
Hidden=false
NoDisplay=false
Name=smartgit
EOF


# Permanently hide the Ubuntu Dock
# sudo apt install dconf-editor
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false

gsettings list-recursively org.gnome.settings-daemon.plugins.power
gsettings set org.gnome.settings-daemon.plugins.power button-power 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'


gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>e"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "nautilus"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "home folder"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Alt><Ctrl>t"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "gnome-terminal"


sudo ln -sf /usr/bin/yapf3 /usr/local/bin/yapf
apm install highlight-selected clang-format language-latex teletype
cat << EOF > ~/.atom/keymap.cson
'atom-workspace atom-text-editor':
  'ctrl-left': 'editor:move-to-previous-word-boundary'
  'ctrl-right': 'editor:move-to-next-word-boundary'
  'ctrl-shift-left': 'editor:select-to-previous-word-boundary'
  'ctrl-shift-right': 'editor:select-to-next-word-boundary'
  'ctrl-backspace': 'editor:delete-to-previous-word-boundary'
  'ctrl-delete': 'editor:delete-to-next-word-boundary'
  'alt-ctrl-/': 'editor:toggle-soft-wrap'
EOF

installation_folder="/packages/pyenv"

if [ ! -d "$installation_folder" ]; then
  sudo mkdir -p $installation_folder
  sudo chown alameddin:alameddin -R /packages
  git clone https://github.com/pyenv/pyenv.git $installation_folder
  git clone https://github.com/pyenv/pyenv-virtualenv.git $installation_folder/plugins/pyenv-virtualenv
  git clone https://github.com/pyenv/pyenv-update.git $installation_folder/plugins/pyenv-update
  # echo "export PYENV_ROOT=$installation_folder" >> ~/.bashrc # or .bash_profile
  # echo "export PATH=$installation_folder/bin:\$PATH" >> ~/.bashrc # or .bash_profile
  # echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  # echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi

sed 's/#\s.*pyenv/eval "$(pyenv/g' ~/.bashrc > ~/.bashrcold
cp ~/.bashrcold ~/.bashrc

source ~/.bashrc
pyenv update

if [ ! "$(ls -A $installation_folder/versions/)" ]; then
  pyenv install 3.6.9
  pyenv install 3.8.2
  pyenv install anaconda3-2020.02
  pyenv virtualenv 3.6.9 sa_env
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv shell sa_env
pip install --upgrade pip wheel setuptools
pip install numpy matplotlib scipy statsmodels tables jupyter jupyterlab sklearn seaborn pyyaml vtk scikit-image h5py pytest scikit-learn parent_import pip install yappi pipreqs tikzplotlib jax jaxlib --upgrade
pip install spams --upgrade # you may need libopenblas-dev
pip install tensorflow --upgrade

if [ "$(lspci | grep -i nvidia)" ]; then
  echo "nvidia"
  pip install tensorflow-gpu --upgrade
else
  echo "intel"
fi
