FROM debian:bookworm

ARG PHP_VERSION=8.3
ARG MAGENTO_VERSION=2.4.8-p3

ENV DB_PORT=3306 \
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

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64] https://mirror.mariadb.org/repo/11.4/debian bookworm main'

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
        libapache2-mod-fcgid \
        apache2 \
        mariadb-server \
        mariadb-client \
        ssl-cert \
        wget \
        cron \
        unzip \
        gnupg \
        curl \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        nano

RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x
RUN apt-get update \
    && apt-get install -y php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-xsl\
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-simplexml \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-zip

RUN a2enmod proxy_fcgi setenvif
RUN a2enconf php${PHP_VERSION}-fpm

RUN groupadd -g 1005 opensearch && useradd -m -u 1005 -g opensearch opensearch
ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.tar.gz" /home/opensearch
WORKDIR /home/opensearch
RUN tar -xvf opensearch-2.11.1-linux-x64.tar.gz
RUN chown -R opensearch:opensearch .
USER opensearch
RUN sed -i '/exec \$OPENSEARCH_HOME\/bin\/opensearch "\$@"/d' opensearch-2.11.1/opensearch-tar-install.sh
RUN opensearch-2.11.1/opensearch-tar-install.sh

USER root

ADD "https://github.com/magento/magento2/archive/refs/tags/${MAGENTO_VERSION}.tar.gz" /var/www/html
WORKDIR /var/www/html
RUN tar -xf ${MAGENTO_VERSION}.tar.gz --strip-components 1
RUN rm ${MAGENTO_VERSION}.tar.gz

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --quiet \
	&& rm composer-setup.php \
	&& mv composer.phar /usr/local/bin/composer

EXPOSE 80
CMD apachectl -D FOREGROUND