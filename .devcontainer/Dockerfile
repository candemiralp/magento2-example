FROM php:8.3-apache

WORKDIR /var/www/html
RUN rm -rf /var/www/html && ln -s /workspaces/$(basename $PWD)/src /var/www/html

EXPOSE 8080

CMD exec apache2-foreground
