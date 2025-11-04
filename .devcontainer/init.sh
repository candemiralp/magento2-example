#!/bin/bash

service mariadb restart
service apache2 restart

MAGENTO_HOST="${CODESPACE_NAME}-80.app.github.dev"

mariadb -e "
  CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
  GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
  FLUSH PRIVILEGES;"

while [ $RET -ne 0 ]; do
  echo "Checking if Opensearch is available."
  curl -XGET "localhost:9200/_cat/health?v&pretty" >/dev/null 2>&1
  RET=$?

  if [ $RET -ne 0 ]; then
    echo "Connection to OpenSearch is pending."
    sleep 5
  fi
done
echo "OpenSearch server is available."

cd /var/www/html

composer install -n

find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R www-data:www-data .
chmod u+x bin/magento

bin/magento setup:install \
  --base-url="http://$MAGENTO_HOST" \
  --db-host="localhost:$DB_PORT" \
  --db-name="$DB_NAME" \
  --db-user="$DB_USER" \
  --db-password="$DB_PASS" \
  --db-prefix="$DB_PREFIX" \
  --admin-firstname="$ADMIN_NAME" \
  --admin-lastname="$ADMIN_LASTNAME" \
  --admin-email="$ADMIN_EMAIL" \
  --admin-user="$ADMIN_USERNAME" \
  --admin-password="$ADMIN_PASSWORD" \
  --backend-frontname="$ADMIN_URLEXT" \
  --language=en_US \
  --currency=EUR \
  --timezone=Europe/Amsterdam \
  --use-rewrites=1 \
  --cleanup-database \
  --search-engine="opensearch" \
  --opensearch-host="localhost" \
  --opensearch-port="9200" \
  --opensearch-index-prefix="magento2" \
  --opensearch-timeout="15"

bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f
bin/magento indexer:reindex
bin/magento deploy:mode:set developer
bin/magento maintenance:disable
bin/magento cron:install

bin/magento setup:store-config:set \
  --base-url-secure="https://$MAGENTO_HOST" \
  --use-secure=1 \
  --use-secure-admin=1
echo "SSL for Magento is configured."

echo "ServerName $MAGENTO_HOST" >> /etc/apache2/apache2.conf
echo "ServerName is added to Apache config."

exec apache2-foreground
