echo "start with:
https://askubuntu.com/questions/450895/mount-luks-encrypted-hard-drive-at-boot
copy hidden files to external disk
/etc/crypttab && /etc/fstab
sdb1 UUID=75ff611d-0ae0-4847-bf41-d71b74cfeaaa none luks,discard
UUID=f1cccd0d-0d85-4d68-924e-9636e79bbf9d	/home	auto	defaults	0	0
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

fedora xorg (for yakuake sake)
nextcloud account
dropbox account
chrome account
check powertop
pycharm
atom as editor
notifications yakuake
tweaks
"

echo "TODO:
unison sync and dropbox
test docker
"


bash -c "cd ~ && rm -rf Documents/ Downloads/ Music/ Pictures/ Public/ Templates/ Videos/"

source /etc/os-release

if [ "$ID" == "ubuntu" ]; then
  sudo apt install -y ansible snapd
elif [ "$ID" == "fedora" ]; then
  sudo dnf install -y ansible snapd
  sudo dnf install fedora-workstation-repositories
  sudo dnf config-manager --set-enabled google-chrome
  sudo ln -sf /var/lib/snapd/snap /snap
  # sudo dnf install -y grubby && grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0" && reboot
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

cat << EOF | tee ~/.config/autostart/nextcloudignore.sh && chmod a+x ~/.config/autostart/nextcloudignore.sh
cd ~
ls -d .* | sed '/.ssh/d' | sed '/.bash./d' | sed '/.detox./d' | sed '/.hidden/d' | sed '/.profile/d' | sed '/.gitconfig/d' | sed '/.gnupg/d' | sed '/.yapf/d' | sed '/.clang/d' | sed '/.selected_editor/d' | sed '$ a .htaccess' > .sync-exclude.lst
EOF

sudo ansible-playbook -v second_step.yml --extra-vars "user=$USER"
./third_step.sh
