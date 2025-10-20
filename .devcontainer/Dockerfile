FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y \
        mariadb-server

WORKDIR /var/www/html

RUN ln -s /workspaces/$(basename $PWD)/src /var/www/html

EXPOSE 80

CMD exec apache2-foreground
