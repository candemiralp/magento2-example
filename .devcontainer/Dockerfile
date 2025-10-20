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
          mariadb-server \
          gnupg \
          curl

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) bcmath gd intl pdo_mysql simplexml soap sockets xsl zip ftp

WORKDIR /var/www/html

ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.deb" /var/www/html
RUN dpkg -i opensearch-2.11.1-linux-x64.deb
RUN rm opensearch-2.11.1-linux-x64.deb

EXPOSE 80

CMD exec apache2-foreground
