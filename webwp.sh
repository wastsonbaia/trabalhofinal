#!/bin/bash

#INSTALA O O QUE É NECESSÁRIO
sudo apt -y update
sudo apt -y install php-curl php-gd php-mbstring php-xml php-xmlrpc
sudo apt-get -y install mysql-server
sudo apt -y install apache2
sudo apt -y install php libapache2-mod-php php-mysql
sudo apt install curl
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

#CONFIGURA MYSQL PRA RECEBER O WORDPRESS
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';

FLUSH PRIVILEGES;
EOF

#ALGUMAS MODIFICAÇÕES NO APACHE2

sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/apache2/apache2.conf
sudo a2dissite 000-default.conf
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
sudo su
cd /var/www/html
sudo mkdir wordpress
cd /var/www/html/wordpress
sudo chown -R `whoami`:www-data /var/www/html/wordpress
wp core download --locale=pt_BR
#CONFIGURANDO BD DO WORDPRESS
sudo mv wp-config-sample.php wp-config.php

sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/admin/g' wp-config.php
sed -i 's/password_here/root/g' wp-config.php
sed -i "s/localhost/$IP_PRIVATE_BD/g" wp-config.php
IP_Public="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)" 
wp core install --url=http://IP_Public/d --title=Blog\ Cozinha --admin_user=admin --admin_password=123456 --admin_email=teste@teste.com.br
