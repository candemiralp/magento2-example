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

if [[ -e /usr/local/bin/composer ]]; then
	echo "Composer already exists"
else
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php composer-setup.php --quiet
	rm composer-setup.php
	mv composer.phar /usr/local/bin/composer
fi

cd /var/www/html

# wget https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz

tar -xf 2.4.8-p3.tar.gz --strip-components 1
rm 2.4.8-p3.tar.gz

composer install -n

# exec apache2-foreground
