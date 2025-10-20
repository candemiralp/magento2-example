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

mv /tmp/magento.tar.gz /var/www/html
mv /tmp/sample-data.tar.gz /var/www

mkdir ../sample-data
tar -xf ../sample-data.tar.gz --strip-components 1 -C ../sample-data
rm ../sample-data.tar.gz
php -f ../sample-data/dev/tools/build-sample-data.php -- --ce-source="/var/www/html"
bin/magento setup:upgrade

tar -xf magento.tar.gz --strip-components 1
rm magento.tar.gz

exec apache2-foreground
