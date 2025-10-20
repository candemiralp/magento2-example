FROM ubuntu:22.04

# Install PHP, NGINX, and required tools
RUN apt-get update && apt-get install -y \
    nginx \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-cli \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-xdebug \
    curl \
    nano \
    git \
    unzip \
    && apt-get clean

# Configure PHP
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
    && echo "cgi.fix_pathinfo=0" >> /etc/php/8.2/fpm/php.ini

# Copy NGINX config
COPY nginx.conf /etc/nginx/sites-available/default

# Create web root
RUN mkdir -p /var/www/html

# Set working directory
WORKDIR /var/www/html

RUN rm -rf /var/www/html && ln -s /workspaces/$(basename $PWD)/src /var/www/html

# Expose HTTP port
EXPOSE 80

# Start services on container start
CMD service php8.2-fpm start && nginx -g 'daemon off;'
