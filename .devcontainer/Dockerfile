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

WORKDIR /var/www/html

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
          software-properties-common \
          lsb-release \
          nano \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x
RUN apt-get update \
    && apt-get install -y php8.3-fpm libapache2-mod-fcgid openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

RUN a2enmod proxy_fcgi setenvif && a2enconf php8.3-fpm

ADD "https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.deb" /tmp/opensearch.deb
ADD "https://github.com/magento/magento2/archive/refs/tags/2.4.8-p3.tar.gz" /var/www/html

RUN apt-get update && apt-get install -y sed && rm -rf /var/lib/apt/lists/* \
    && dpkg -i /tmp/opensearch.deb || true \
    && if [ -f /var/lib/dpkg/info/opensearch.postinst ]; then \
         sed -i -E 's/(systemctl|invoke-rc.d|service)/echo "Skipping systemd"/g' /var/lib/dpkg/info/opensearch.postinst; \
         echo "exit 0" > /var/lib/dpkg/info/opensearch.postinst; \
       fi \
    && dpkg --configure -a || true \
    && apt-get install -f -y || true \
    && groupadd --system opensearch || true \
    && useradd --system --gid opensearch --no-create-home --shell /bin/false opensearch || true \
    && mkdir -p /usr/share/opensearch /var/lib/opensearch /var/log/opensearch /etc/opensearch \
    && chown -R opensearch:opensearch /usr/share/opensearch /var/lib/opensearch /var/log/opensearch /etc/opensearch \
    && rm -f /tmp/opensearch.deb

EXPOSE 80 9200 9600

CMD ["apachectl", "-D", "FOREGROUND"]
