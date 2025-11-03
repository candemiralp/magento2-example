#!/bin/bash

service mariadb restart

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

if [ "$OPENSEARCH_SERVER" != "<will be defined>" ]; then
	MAGENTO_INSTALL_ARGS=$(echo \
	    --search-engine="opensearch" \
		--opensearch-host="$OPENSEARCH_SERVER" \
		--opensearch-port="$OPENSEARCH_PORT" \
		--opensearch-index-prefix="$OPENSEARCH_INDEX_PREFIX" \
		--opensearch-timeout="$OPENSEARCH_TIMEOUT")
	RET=1
	while [ $RET -ne 0 ]; do
		echo "Checking if $OPENSEARCH_SERVER is available."
		curl -XGET "$OPENSEARCH_SERVER:$OPENSEARCH_PORT/_cat/health?v&pretty" >/dev/null 2>&1
		RET=$?

		if [ $RET -ne 0 ]; then
			echo "Connection to OpenSearch is pending."
			sleep 5
		fi
	done
	echo "OpenSearch server $OPENSEARCH_SERVER is available."
fi

composer install -n

find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R www-data:www-data .
chmod u+x bin/magento

bin/magento setup:install \
  --base-url="http://$MAGENTO_HOST" \
  --db-host="$DB_SERVER:$DB_PORT" \
  --db-name="$DB_NAME" \
  --db-user="$DB_USER" \
  --db-password="$DB_PASSWORD" \
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
  $MAGENTO_INSTALL_ARGS;

bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f
bin/magento indexer:reindex
bin/magento deploy:mode:set developer
bin/magento maintenance:disable
bin/magento cron:install

echo "Installation completed"

bin/magento setup:store-config:set \
  --base-url-secure="https://$MAGENTO_HOST" \
  --use-secure=1 \
  --use-secure-admin=1
echo "SSL for Magento is configured."

echo "ServerName $MAGENTO_HOST" >> /etc/apache2/apache2.conf
echo "ServerName is added to Apache config."


# exec apache2-foreground
