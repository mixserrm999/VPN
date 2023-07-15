#!/bin/bash
#script by tbmods for ubuntu 20.04

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#install openvpn

apt-get purge openvpn easy-rsa -y;
apt-get purge squid -y;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get install bc -y
apt-get -y install openvpn easy-rsa;
apt-get -y install python3;

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/mixserrm999/VPN/main/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/mixserrm999/VPN/main/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
systemctl restart openvpn

#install squid3

apt-get -y install squid;
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/mixserrm999/VPN/main/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
systemctl restart squid

#config client
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/mixserrm999/VPN/main/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

ufw allow ssh
ufw allow 443/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable

# download script
cd /usr/bin
wget -O member "https://raw.githubusercontent.com/mixserrm999/VPN/main/member.sh"
wget -O menu "https://raw.githubusercontent.com/mixserrm999/VPN/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/mixserrm999/VPN/main/usernew.sh"
wget -O speedtest "https://raw.githubusercontent.com/mixserrm999/VPN/main/speedtest_cli.py"
wget -O userd "https://raw.githubusercontent.com/mixserrm999/VPN/main/deluser.sh"
wget -O trial "https://raw.githubusercontent.com/mixserrm999/VPN/main/trial.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
#echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x member
chmod +x menu
chmod +x usernew
chmod +x speedtest
chmod +x userd
chmod +x trial
clear

printf '###############################\n'
printf '# Script by  tbmods           #\n'
printf '#                             #\n'

printf '#                             #\n'
printf '#    พิมพ์ menu เพื่อใช้คำสั่งต่างๆ   #\n'
printf '###############################\n\n'
echo -e "ดาวน์โหลดไฟล์  : /root/client.ovpn\n\n"
printf '\n\nเพิ่ม user โดยใช้คำสั่ง useradd'
printf '\n\nตั้งรหัสโดย ใช้คำสั่ง passwd'
printf '\n\nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi

