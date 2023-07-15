#!/bin/bash

sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")
adminuser=$(mysql -N -e "use ShaHaN; select adminuser from setting where id='1';")
adminpass=$(mysql -N -e "use ShaHaN; select adminpassword from setting where id='1';")
clear
if [ "$adminuser" != "" ]; then
adminusername=$adminuser
adminpassword=$adminpass
else
adminusername=admin
echo -e "\nPlease input Panel admin user."
printf "Default user name is \e[33m${adminusername}\e[0m, let it blank to use this user name: "
read usernametmp
if [[ -n "${usernametmp}" ]]; then
    adminusername=${usernametmp}
fi
adminpassword=123456
echo -e "\nPlease input Panel admin password."
printf "Default password is \e[33m${adminpassword}\e[0m, let it blank to use this password : "
read passwordtmp
if [[ -n "${passwordtmp}" ]]; then
    adminpassword=${passwordtmp}
fi
fi


file=/etc/systemd/system/videocall.service
if [ -e "$file" ]; then
    echo "SSH-CALLS exists"
else
udpport=7300
echo -e "\nPlease input UDPGW Port ."
printf "Default Port is \e[33m${udpport}\e[0m, let it blank to use this Port: "
read udpport
fi


ipv4=$(curl -s ipv4.icanhazip.com)
sudo sed -i '/www-data/d' /etc/sudoers &
wait
sudo sed -i '/apache/d' /etc/sudoers & 
wait

sed -i 's@#Banner none@Banner /var/www/html/p/banner.txt@' /etc/ssh/sshd_config
sed -i 's@#PrintMotd yes@PrintMotd yes@' /etc/ssh/sshd_config
sed -i 's@#PrintMotd no@PrintMotd yes@' /etc/ssh/sshd_config


if command -v apt-get >/dev/null; then
apt update -y

rm -fr /etc/php/7.4/apache2/conf.d/00-ioncube.ini
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
apt install apache2 zip unzip net-tools curl mariadb-server  -y

apt remove php7* -y &
wait
string=$(php -v)
if [[ $string == *"8.1"* ]]; then

apt autoremove -y
  echo "PHP Is Installed :)"
else
apt remove php* -y
apt remove php -y
apt autoremove -y
apt install php8.1 php8.1-mysql php8.1-xml php8.1-curl cron -y
fi





link=$(sudo curl -Ls "https://api.github.com/repos/Quick-Server/Super-SSH-User-Manager/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget -O /var/www/html/update.zip $link
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait

sudo service apache2 restart
chown -R www-data:www-data /var/www/html/p/* &
wait

systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
elif command -v yum >/dev/null; then
yum update -y

sudo yum -y install https://github.com/Quick-Server/Super-SSH-User-Manager/raw/main/Requirements/epel-release-latest-7.noarch.rpm
sudo yum -y install https://github.com/Quick-Server/Super-SSH-User-Manager/raw/main/Requirements/remi-release-7.rpm
sudo yum -y install yum-utils
yum remove php -y
yum autoremove -y


yum install epel-release httpd zip unzip net-tools curl mariadb-server php8.1 php8.1-cli php8.1-mysql php8.1-mysqli php8.1-xml mod_ssl php8.1-curl -y
systemctl restart httpd
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
link=$(sudo curl -Ls "https://api.github.com/repos/Quick-Server/Super-SSH-User-Manager/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget -O /var/www/html/update.zip $link
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/reboot' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")

systemctl restart httpd
systemctl enable httpd
systemctl restart sshd
chown -R apache:apache /var/www/html/p/* &
wait

chmod 644 /etc/ssh/sshd_config &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
fi

IonCube=$(php -v)
if [[ $IonCube == *"PHP Loader v12.0.5"* ]]; then
  echo "IonCube Is Installed :)"
else
bash <(curl -Ls https://raw.githubusercontent.com/Quick-Server/Super-SSH-User-Manager/main/Requirements/ioncube.sh --ipv4)
fi

Nethogs=$(nethogs -V)
if [[ $Nethogs == *"version 0.8.7"* ]]; then
  echo "Nethogs Is Installed :)"
else
bash <(curl -Ls https://raw.githubusercontent.com/Quick-Server/Super-SSH-User-Manager/main/Requirements/nethogs.sh --ipv4)
fi

file=/etc/systemd/system/videocall.service
if [ -e "$file" ]; then
    echo "SSH-CALLS exists"
else
apt update -y
apt install git cmake -y
git clone https://github.com/ambrop72/badvpn.git /root/badvpn
mkdir /root/badvpn/badvpn-build
cd  /root/badvpn/badvpn-build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 &
wait
make &
wait
cp udpgw/badvpn-udpgw /usr/local/bin
cat >  /etc/systemd/system/videocall.service << ENDOFFILE
[Unit]
Description=UDP forwarding for badvpn-tun2socks
After=nss-lookup.target

[Service]
ExecStart=/usr/local/bin/badvpn-udpgw --loglevel none --listen-addr 127.0.0.1:$udpport --max-clients 999
User=videocall

[Install]
WantedBy=multi-user.target
ENDOFFILE
useradd -m videocall
systemctl enable videocall
systemctl start videocall
fi


mysql -e "create database ShaHaN;" &
wait
mysql -e "CREATE USER '${adminusername}'@'localhost' IDENTIFIED BY '${adminpassword}';" &
wait
mysql -e "GRANT ALL ON *.* TO '${adminusername}'@'localhost';" &
wait
sudo sed -i "s/22/$port/g" /var/www/html/p/config.php &
wait 
sudo sed -i "s/adminuser/$adminusername/g" /var/www/html/p/config.php &
wait 
sudo sed -i "s/adminpass/$adminpassword/g" /var/www/html/p/config.php &
wait 

sudo sed -i "s/SERVERUSER/$adminusername/g" /var/www/html/p/killusers.sh &
wait 
sudo sed -i "s/SERVERPASSWORD/$adminpassword/g" /var/www/html/p/killusers.sh &
wait 
sudo sed -i "s/SERVERIP/$ipv4/g" /var/www/html/p/killusers.sh &
wait 
php /var/www/html/p/restoretarikh.php
curl http://${ipv4}/p/versioncheck.php
cp /var/www/html/p/tarikh /var/www/html/p/backup/tarikh
rm -fr /var/www/html/p/tarikh
rm -fr /var/www/html/update.zip

nowdate=$(date +"%Y-%m-%d-%H-%M-%S")
mysqldump -u ${adminusername} --password=${adminpassword} ShaHaN > /var/www/html/p/backup/${nowdate}-full-installbackup.sql

crontab -l | grep -v '/p/expire.php'  | crontab  -
crontab -l | grep -v '/p/posttraffic.php'  | crontab  -
crontab -l | grep -v '/p/synctraffic.php'  | crontab  -
crontab -l | grep -v 'p/killusers.sh'  | crontab  -
crontab -l | grep -v 'p/versioncheck.php'  | crontab  -
(crontab -l ; echo "* */3 * * * php /var/www/html/p/versioncheck.php >/dev/null 2>&1
* * * * * php /var/www/html/p/expire.php >/dev/null 2>&1
* * * * * php /var/www/html/p/posttraffic.php >/dev/null 2>&1
* * * * * bash /var/www/html/p/killusers.sh >/dev/null 2>&1" ) | crontab - &
wait
sudo timedatectl set-timezone Asia/Tehran
chmod 0644 /var/log/auth.log
clear
printf "%s" "$(</var/www/html/start.txt)"
printf "\n \n"
printf "\nPanel Link : http://${ipv4}/p/index.php"
printf "\nUserName : \e[31m${adminusername}\e[0m "
printf "\nPassWord : \e[31m${adminpassword}\e[0m "
printf "\nPort : \e[31m${port}\e[0m \n"
