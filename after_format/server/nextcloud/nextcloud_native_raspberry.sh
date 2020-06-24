# ansible setup
# http://unixetc.co.uk/2017/11/25/automatic-nextcloud-installation-on-raspberry-pi/
sudo apt-get -y install ansible
wget https://raw.githubusercontent.com/webtaster/Nextcloud/master/build_nextcloud.yml
date ; ansible-playbook --become -c local -i "localhost," --extra-vars "DATABASE=mysql MYSQL_ROOT_PASSWORD=mypassword NCUSER_PASSWORD=mypassword" build_nextcloud.yml


############################################################################
############################################################################
############################################################################


# manual setup
# https://pimylifeup.com/raspberry-pi-nextcloud-server/
usermod -aG sudo $USER

sudo mkdir -p /mnt/ssd
sudo chown -R pi:pi /mnt/ssd
cd /mnt/data
mkdir -p nextcloud_native
sudo chown -R www-data:www-data nextcloud_native

# mount a derive permanently
lsblk -o name,mountpoint,size,uuid
sudo nano /etc/fstab
UUID=2E61F2F02980F101 /mnt/clouddrive ntfs-3g defaults,permissions,nofail
sudo chmod -R o-rwx /mnt/clouddrive

apt-get install realvnc-vnc-server realvnc-vnc-viewer php-cli php-fpm php-json php-intl php-imagick php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath wget ntfs-3g php-gd php-curl php-apcu hdparm wget unzip apache2 libapache2-mod-php mariadb-server etherwake -y
apt-get update -y && apt-get upgrade -y

a2enmod proxy_fcgi setenvif
a2enconf php7.3-fpm
systemctl restart apache2

# mysql -u root -p
sudo mysql -u root
SELECT User,Host FROM mysql.user;
DROP USER 'root'@'localhost';
CREATE USER 'root'@'%' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
CREATE USER 'nextcloud'@'localhost' identified by 'mypassword';
CREATE DATABASE nextcloud;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost'; FLUSH PRIVILEGES;
QUIT;

# sudo rm -rf /var/www/nextcloud
wget https://download.nextcloud.com/server/releases/latest-17.zip
unzip latest-17.zip
rm -f latest-17.zip
sudo mv nextcloud /var/www/
sudo chown -R www-data:www-data /var/www/nextcloud/

echo "<?php
// Show all information, defaults to INFO_ALL
phpinfo();
?>" > /var/www/html/phpinfo.php

# make it accessable through localhost/nextcloud
su -
echo "Alias /nextcloud "/var/www/nextcloud/"
<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All
 <IfModule mod_dav.c>
  Dav off
 </IfModule>
 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud
</Directory>
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]" > /etc/apache2/conf-available/nextcloud.conf
mv /etc/apache2/sites-enabled/000-default.conf /home/$USER/
a2enmod ssl
a2ensite default-ssl
service apache2 reload
a2enconf nextcloud
a2enmod rewrite dir mime env headers dav
systemctl reload apache2
systemctl restart apache2

cd /var/www/nextcloud
sudo -u www-data php occ db:convert-filecache-bigint
sudo nano /etc/php/7.3/apache2/php.ini
post_max_size = 8000M
upload_max_filesize = 8000M
memory_limit = 600M
sudo service apache2 restart

cd /mnt/clouddrive
sudo -u www-data php /var/www/nextcloud/console.php files:scan --all
sudo reboot
############################################################################
############################################################################
############################################################################

# ssl certificate
sudo nano /etc/apache2/sites-available/000-default-le-ssl.conf
<VirtualHost *:443>
  ServerName *******.ddns.net
    <IfModule mod_headers.c>
      Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"
    </IfModule>
 </VirtualHost>
sudo a2enmod rewrite
sudo service apache2 restart

# security https://pimylifeup.com/raspberry-pi-fail2ban/
sudo apt-get install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
/var/log/fail2ban.log
sudo service fail2ban status
systemctl enable fail2ban
systemctl start fail2ban
sudo iptables -L f2b-sshd
# ssl https://pimylifeup.com/raspberry-pi-ssl-lets-encrypt/
sudo apt-get install python-certbot-apache
sudo apt-get install certbot
sudo certbot --apache

# config
sudo nano /etc/apache2/conf-available/nextcloud.conf
sudo cat /var/www/nextcloud/config/config.php

# sudo service apache2 restart

# nano /etc/hostname
# nano /etc/hosts

# mysql change password
# mysqladmin -u root -p password ********
# mysqladmin -u root -p -h localhost password ********
# mysqladmin -u nextcloud -p password **********
# mysqladmin -u nextcloud -p -h localhost password ********
# SET PASSWORD FOR 'root'@'%' = PASSWORD('*********');
# SET PASSWORD FOR 'nextcloud'@'localhost' = PASSWORD('**********');

############################## home NAS
# https://www.instructables.com/id/Turn-Raspberry-Pi-into-a-Network-File-System-versi/
# https://www.thegeekdiary.com/mount-nfs-access-denied-by-server-while-mounting-how-to-resolve/
# https://serverfault.com/questions/825246/mount-an-nfs-share-as-non-root-user-in-cli
# https://www.hiroom2.com/2017/08/30/ubuntu-1610-nfs-kernel-server-en/
/mnt/clouddrive/homenas *(rw,sync,insecure,all_squash,no_subtree_check)

############################## maintenance
https://docs.nextcloud.com/server/10.0/admin_manual/configuration_server/occ_command.html#trashbin-label
# sudo -u www-data php occ trashbin:cleanup --all-users
