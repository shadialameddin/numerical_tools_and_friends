cat << EOF | sudo tee /etc/systemd/system/powertop.service
[Unit]
Description=PowerTOP auto tune
[Service]
Type=idle
Environment="TERM=dumb"
ExecStart=/usr/sbin/powertop --auto-tune
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable powertop.service
sudo systemctl start powertop.service
# MOUSE="/sys/bus/usb/devices/3-1.2/power/control";
# if [ -f "$MOUSE" ]; then
# 	echo 'on' > $MOUSE;
# fi


# [Desktop Entry]
# Name=matlab
# # Icon=/z_packages/matlab.png
# Exec=/z_packages/matlab/bin/matlab -desktop
# Type=Application
# [Desktop Entry]
# Name=pycharm
# Exec=/z_packages/pycharm/bin/pycharm.sh
# TryExec=/z_packages/pycharm/bin/pycharm.sh
# Terminal=false
# Type=Application

sudo ln -sf /usr/bin/yapf3 /usr/local/bin/yapf
apm install highlight-selected clang-format language-latex teletype


installation_folder="/packages/pyenv"

cat << EOF | tee deleteme.sh && chmod +x deleteme.sh && ./deleteme.sh && rm deleteme.sh
# sudo mkdir -p $installation_folder
# sudo chmod -R a+rwx /packages
if [ ! -d "$installation_folder" ]; then
  git clone https://github.com/pyenv/pyenv.git $installation_folder
  git clone https://github.com/pyenv/pyenv-virtualenv.git $installation_folder/plugins/pyenv-virtualenv
  git clone https://github.com/pyenv/pyenv-update.git $installation_folder/plugins/pyenv-update
else
  pyenv update
fi
source ~/.bashrc
EOF
# echo "export PYENV_ROOT=$installation_folder" >> ~/.bashrc # or .bash_profile
# echo "export PATH=$installation_folder/bin:\$PATH" >> ~/.bashrc # or .bash_profile
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

cat << EOF | tee deleteme.sh && chmod +x deleteme.sh && ./deleteme.sh && rm deleteme.sh
# if not empty
if [ ! "$(ls -A $installation_folder/versions/)" ]; then
  pyenv install 3.6.9
  pyenv install 3.8.2
  pyenv install anaconda3-2020.02
  pyenv virtualenv 3.6.9 sa_env
  # pyenv global 3.6.9
  # pyenv activate sa_env
fi
source ~/.bashrc
EOF

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
