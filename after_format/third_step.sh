sudo ln -sf /usr/bin/yapf3 /usr/local/bin/yapf
apm install highlight-selected clang-format language-latex teletype

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
