# Apache webserver // php // MariaDB (mysql)
username pi
password raspberry

su -
systemctl enable ssh
systemctl start ssh
adduser alameddin
usermod -aG sudo alameddin

# setup time & ... sudo raspi-config
sudo rpi-update
sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
sudo apt full-upgrade -y
sudo apt install rpi-eeprom -y
sudo apt-get install unattended-upgrades apt-listchanges bsd-mailx postfix -y

sudo apt install python3-pip
pip3 install --user RPi.GPIO

https://learn.sparkfun.com/tutorials/raspberry-gpio/python-rpigpio-api
https://www.raspberrypi.org/documentation/usage/gpio/
https://www.raspberrypi.org/documentation/usage/gpio/python/README.md

import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(21,GPIO.OUT)
print "LED on"
GPIO.output(21,GPIO.HIGH)
time.sleep(10)
print "LED off"
GPIO.output(21,GPIO.LOW)
