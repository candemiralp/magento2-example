FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y \
        mariadb-server

WORKDIR /var/www/html

ARG MAGENTO_VERSION="2.4.8-p3"
ADD "https://github.com/magento/magento2/archive/refs/tags/${MAGENTO_VERSION}.tar.gz" /var/www/html
# ADD "https://github.com/magento/magento2-sample-data/archive/refs/tags/${MAGENTO_VERSION}.tar.gz" /tmp/sample-data.tar.gz

EXPOSE 80

CMD exec apache2-foreground
