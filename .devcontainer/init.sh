#!/bin/bash

service mariadb restart

DB_NAME="magento"
DB_USER="magento"
DB_PASS="magento"

mariadb -e "
  CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
  GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
  FLUSH PRIVILEGES;"

cd /var/www/html

wget https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz

tar -xf 2.4.8-p3.tar.gz --strip-components 1
rm 2.4.8-p3.tar.gz

composer install -n

exec apache2-foreground
