FROM debian:bookworm

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
          apache2 \
          curl

WORKDIR /var/www/html

ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-arm64.deb" /var/www/html
ADD "https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz" /var/www/html
RUN dpkg -i opensearch-2.11.1-linux-arm64.deb
RUN rm opensearch-2.11.1-linux-arm64.deb

EXPOSE 80

CMD apachectl -D FOREGROUND
