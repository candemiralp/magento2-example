FROM debian:bookworm

ENV MAGENTO_HOST=$CODESPACE_NAME \
    DB_PORT=3306 \
    DB_NAME="magento" \
    DB_USER="magento" \
    DB_PASS="magento" \
    DB_PREFIX="m2_" \
    ADMIN_NAME="Admin" \
    ADMIN_LASTNAME="Admin" \
    ADMIN_EMAIL="admin@demo.com" \
    ADMIN_USERNAME="admin" \
    ADMIN_PASSWORD="Admin123@" \
    ADMIN_URLEXT="admin"
#
#RUN apt-get update \
#    && apt-get install -y \
#          libjpeg62-turbo-dev \
#          libpng-dev \
#          libfreetype6-dev \
#          libxml2-dev \
#          libzip-dev \
#          libssl-dev \
#          libxslt-dev \
#          libicu-dev \
#          ssl-cert \
#          wget \
#          cron \
#          unzip \
#          mariadb-server \
#          gnupg \
#          apache2 \
#          curl \
#          ca-certificates \
#          apt-transport-https \
#          software-properties-common  \
#          lsb-release \
#          nano
#
#RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x
#RUN apt-get update \
#    && apt-get install -y php8.3-fpm \
#          libapache2-mod-fcgid
#RUN a2enmod proxy_fcgi setenvif
#RUN a2enconf php8.3-fpm

RUN useradd opensearch && mkdir /home/opensearch
USER opensearch
ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.tar.gz" /home/opensearch
RUN tar -xvf /home/opensearch/opensearch-2.11.1-linux-x64.tar.gz
RUN /bin/bash /home/opensearch/opensearch-2.11.1/opensearch-tar-install.sh

#USER root
#ADD "https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz" /var/www/html
#
#EXPOSE 80
#
#CMD apachectl -D FOREGROUND
