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
          curl \
          ca-certificates \
          apt-transport-https \
          software-properties-common  \
          lsb-release \
          nano

RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x
RUN apt-get update \
    && apt-get install php8.3-fpm \
          libapache2-mod-fcgid
RUN a2enmod proxy_fcgi setenvif
RUN a2enconf php8.3-fpm
run systemctl restart apache2

WORKDIR /var/www/html

ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.deb" /var/www/html
ADD "https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz" /var/www/html
RUN dpkg -i opensearch-2.11.1-linux-x64.deb
RUN rm opensearch-2.11.1-linux-x64.deb

EXPOSE 80

CMD apachectl -D FOREGROUND
