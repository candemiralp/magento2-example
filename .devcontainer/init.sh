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

tar -xf magento.tar.gz --strip-components 1
rm magento.tar.gz

composer install -n

exec apache2-foreground
