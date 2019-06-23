#!/bin/bash
apt-get install mysql-server -y 
debconf-set-selections <<< 'mysql-server mysql-server/ password wordpress' 
sed -i "/bind-address/d" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql.service
mysql <<EOF
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO 'root'@'%' IDENTIFIED BY 'wordpress' WITH GRANT OPTION;
FLUSH PRIVILEGES;
\q;
EOF
