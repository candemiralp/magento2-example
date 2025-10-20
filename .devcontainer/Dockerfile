FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y \
          libjpeg62-turbo-dev \
          libpng-dev \
          libfreetype6-dev \
          libxml2-dev \
          libzip-dev \
          libssl-dev \
          libxslt-dev \
          libicu-dev \
          ssl-cert \
          wget \
          cron \
          unzip \
          mariadb-server

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) bcmath gd intl pdo_mysql simplexml soap sockets xsl zip ftp
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

WORKDIR /var/www/html

EXPOSE 80

CMD exec apache2-foreground
