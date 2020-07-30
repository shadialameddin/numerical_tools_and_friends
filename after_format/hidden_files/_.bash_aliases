# TEXINPUTS
# change texstudio.desktop to use TEXINPUTS

# env
alias forexample="for i in {1..5}; do echo hi; done"

## CPU info
# gcc -march=native -Q --help=target|grep march
# sudo lshw -X
# sudo lshw # here you can see the bus width
# sudo lshw -C memory
# su -c dmidecode
# lscpu
# lspci
# lslogins

########################################### emmawork1
# ln -s /calc-c/sa/src ~/src
# pyminirom new_folder 'main.py --ref=t'
# nohup /usr/bin/time -v python src/test_folder/main.py --dict=t > nohup.log &
alias syncpyminirom="rsync -Pavi --delete --force --delete-excluded --exclude '.*' /home/alameddin/src/pyminirom/ emmawork1:/calc-c/sa/src/pyminirom/" # --exclude 'output/*'
alias syncpydata="rsync -Pavi --delete --force --delete-excluded --exclude '.*' /home/alameddin/src/data/ emmawork1:/calc-c/sa/src/data/" # --exclude 'output/*'
pyminirom() {
	local destinationfolder="${1:-deleteme}"
	local python_file="${2:---version}"
	rsync -Pavi --delete --force --delete-excluded --exclude '.*' /home/alameddin/src/pyminirom/ emmawork1:/calc-c/sa/src/$destinationfolder && ssh emmawork1 "cd /calc-c/sa/src/$destinationfolder && /usr/bin/time -v /opt/anaconda-users/alameddin/envs/sa_env/bin/python -u $python_file"
}
# I had to comment the line that stops processing ~/.bashrc :
# If not running interactively, don't do anything
# [ -z "$PS1" ] && return

################################## web
alias ipa="ip a"
# https://calomel.org/firefox_ssh_proxy.html
# then set firefox to use manual proxy
# SOCKS: localhost
# port:8080
alias proxy="ssh -D 8080 emmawork1"
# fixmac: turn on flight mode then run fixmac
alias fixmac="sudo ip link set dev wlp58s0 address 9c:b6:d0:ee:b1:97" # matlab

################################## remote folders
alias emma="nautilus sftp://alameddin@emmawork1:22/home/alameddin/"
alias robin="nautilus sftp://alameddin@robin:22/home/alameddin/"
# alias dolphin_hertz="dolphin fish://alameddin@hertz:22/home/alameddin/"
# alias dolphin_nextcloud="nautilus davs://alameddin@alameddin.ddns.net/nextcloud/remote.php/webdav"
# sshfs emmawork1:/calc-c/sa/ /home/emmawork/ -o reconnect
# sftp://alameddin@emmawork1/home/alameddin

alias homenas_show="showmount -e 192.168.178.29"
alias homenas_mount="sudo mount -t nfs 192.168.178.29:/home/alameddin/homenas /home/alameddin/z_nosync_homenas"
alias homenas_unmount="sudo umount /home/alameddin/z_nosync_homenas"

################################## language
alias english="export $LANG=en_US.UTF-8"

################################## cleaning commands
alias fixfilenames="detox -rv -s myseq *" # -n dry-run
# removeconflict=_case_conflict_
# alias removecaseconflict="for i in *"$removeconflict"*;do mv "$i" "${i/"$removeconflict"}";done"
alias clang_format_folder="find . -regex '.*\.\(cpp\|hpp\|cc\|cxx\)' -exec clang-format -i {} \;"
alias cleanlatex='find "`pwd`" -name "*.aux" -delete && find "`pwd`" -name "*.xml" -delete && find "`pwd`" -name "*.bcf" -delete && find "`pwd`" -name "*.bbl" -delete && find "`pwd`" -name "*.blg" -delete && find "`pwd`" -name "*.idx" -delete && find "`pwd`" -name "*.ind" -delete && find "`pwd`" -name "*.lof" -delete && find "`pwd`" -name "*.lot" -delete && find "`pwd`" -name "*.out" -delete && find "`pwd`" -name "*.toc" -delete && find "`pwd`" -name "*.acn" -delete && find "`pwd`" -name "*.acr" -delete && find "`pwd`" -name "*.alg" -delete && find "`pwd`" -name "*.glg" -delete && find "`pwd`" -name "*.glo" -delete && find "`pwd`" -name "*.gls" -delete && find "`pwd`" -name "*.ist" -delete && find "`pwd`" -name "*.fls" -delete && find "`pwd`" -name "*.log" -delete && find "`pwd`" -name "*.fdb_latexmk" -delete && find "`pwd`" -name "*.nav" -delete && find "`pwd`" -name "*.snm" -delete && find "`pwd`" -name "*.synctex.gz" -delete'

################################## files and folders
# folder_premission
# ls -l; chmod -R a+rwx blabla
# u=owner g=group o=others a=all, r=read w=write e=excute owner:group
alias md='mkdir'
alias rd='rmdir'

tarzip(){ tar -cvf $1.tar.gz $1 ; }
taruzip(){ tar -xvf $1 ; }
tarzipz(){ tar -czvf $1.tar.gz $1 ; }
taruzipz(){ tar -xzvf $1 ; }

alias disks="lsblk -f"
alias disk_usage="df -h | sort"
alias folder_size="du -sch * | sort -h"
alias folder_size_hidden="du -sch .[!.]* * | sort -h"

################################## install packages
alias apt-find='apt search'
alias apt-inst='sudo apt install'
alias apt-upg='sudo apt update && sudo apt upgrade && sudo apt autoremove'
# alias install_rpm_locally="rpm2cpio name.rpm | cpio -idv"
# yumdownloader --destdir ~/rpm --resolve vim-common
# The command I meant is yumdownloader. I don't know if with root access you can use a different command. But with that you don't need to download the .rpm file from the website.
# https://stackoverflow.com/questions/36651091/how-to-install-packages-in-linux-centos-without-root-user-with-automatic-depen

# https://docs.brew.sh/Homebrew-on-Linux
# Homebrew on Linux (install packages locally without sudo)
################################## build neon
# alias buildneon="cd ~/src/neon/build && cmake .. && make all -j6 && ctest"
# alias buildcodeneon="cd ~/src/neon/ && doxygen doc/Doxyfile" #&& rm -rf doc/html
# alias builddocneon="cd ~/src/neon/doc/ && make html"

################################## find
alias findfile="find . -iname"
alias findtxt1="grep -i"
alias findtxt2="java -jar searchmonkey-3.2.0.jar"

alias findpdf1="pdfgrep -ri"
alias findpdf2="find /path -iname '*.pdf' -exec pdfgrep pattern {} +"
alias findpdf3="acroread"
alias find_duplicate="fdupes -rd *"
alias find_duplicate_fslint="fslint-gui"


################################## backup
# alias backup="cp -f ~/.gitconfig /home/alameddin/0_home/0_softwares/z_new_installation/backup/gitconfig && cp -f ~/.bashrc /home/alameddin/0_home/0_softwares/z_new_installation/backup/bashrc && cp -rf ~/.gnupg/* /home/alameddin/0_home/0_softwares/z_new_installation/backup/gnupg && cp -rf ~/.ssh/* /home/alameddin/0_home/0_softwares/z_new_installation/backup/ssh"
# # && PASSPHRASE="sjah1234_akdjklas18237][@" duplicity --exclude='/home/alameddin/.*' --exclude='/home/alameddin/zzz_dont_sync' -v 5 /home/alameddin/ file:///z_backup/
# alias backup_full="PASSPHRASE="sjah1234_akdjklas18237][@" duplicity full --exclude='/home/alameddin/.*' --exclude='/home/alameddin/zzz_dont_sync' -v 5 /home/alameddin/ file:///z_backup/ && duplicity remove-all-but-n-full 3 --force file:///z_backup/"
# alias backup_verify="duplicity verify -v 5 file:///z_backup/ /home/alameddin"
# alias send_backup="rsync -Pavi --delete --force --delete-excluded /z_backup/ hertz:/home/alameddin/backup"
# alias send_romfem="rsync -Pavi --delete --force --delete-excluded --exclude 'output/*' ~/src/romfem dirichlet:/home/alameddin/"
# alias send_backup_hdd="backup && rsync -Pavi --delete --force --delete-excluded /z_* /run/media/alameddin/ibnm_hdd/"
# # duplicity list-current-files file:///z_backup/ | grep ....
# # PASSPHRASE="sjah1234_akdjklas18237][@" duplicity --file-to-restore 2.txt file:///zz_backup/ ~/zzzzzzz/
# # -t 3D 3 days ago
# # http://duplicity.nongnu.org/duplicity.1.html
# # https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu
# # [restore files] deja-dup --restore .ssh .gnupg .gitconfig .bashrc


################################## remote run
# # -a --all-tasks/threads
# pidof atom
# taskset -a -p -c <pid>
# taskset -a -p -c <cpu-list> <pid>
# ps -up <pid>
# for pid in $(ps -eLf | awk '{print $2}'); do taskset -a -c -p $pid; done
# If the process name (which appears under the column COMMAND) is shown inside square brackets (e.g. [kdmflush]), it is a kernel thread.
# ps aux | grep sathiya
#
# # stdin, stdout, and stderr 1>&2
# /proc/<pid>/fd and look at 1 which is stdout
# nohup ./myprogram > foo.out 2> foo.err < /dev/null &
#
# # Unfortunately disown is specific to bash and not available in all shells.
# disown -h job [even if they were not started with nohup]
# ctrl+z
# bg to run it in the background.
# # fg
# jobs
# disown -h %1
# disown -a


################################## sound
alias sampling_rate="pactl list short sinks"
alias sound_control="pulsemixer"
alias sound_control_gui="pavucontrol"
# sudo apt install paprefs [Play sound through two or more outputs/devices]
# https://askubuntu.com/questions/18958/realtime-noise-removal-with-pulseaudio

################################## nextcloud
# root@robin:/var/www/nextcloud# sudo -u www-data php occ trashbin:cleanup --all-users
# https://docs.nextcloud.com/server/10.0/admin_manual/configuration_server/occ_command.html




alias youtubedl="youtube-dl"
alias youtubedl50="youtube-dl -f 'best[filesize<50M]'"
alias youtubedl100="youtube-dl -f 'best[filesize<100M]'"
alias youtubedlsmall="youtube-dl -f 'bestvideo[height<=480]+bestaudio/best[height<=480]'"
