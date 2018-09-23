FROM devwithlando/php:7.1-apache

ENV LANDO_WEBROOT=/app/. \
LANDO_SERVICE_NAME=appserver \
LANDO_SERVICE_TYPE=php \
LANDO='ON' \
LANDO_DOMAIN=drupal.jx-hgajjar-drupal-pr-1.35.234.16.53.nip.io \
LANDO_APP_NAME=drupal \
LANDO_APP_ROOT=/app \
LANDO_WEBROOT_USER=www-data \
LANDO_WEBROOT_GROUP=www-data \
LANDO_WEBROOT_UID='33' \
LANDO_WEBROOT_GID='33'

ENV PORT 80
EXPOSE 80

WORKDIR /app
COPY . .

COPY docker/config/php/php.ini /usr/local/etc/php/conf.d/xxx-lando-default.ini
COPY docker/config/php/httpd-ssl.conf /etc/apache2/sites-enabled/000-default.conf
COPY docker/config/drupal8/php.ini /usr/local/etc/php/conf.d/zzz-lando-my-custom-ini-file-called-php.ini

RUN composer install \
  && chown -R www-data:www-data .

ENTRYPOINT [ "/lando-entrypoint.sh" ]
CMD [ "docker-php-entrypoint", "sh", "-c", "a2enmod rewrite && apache2-foreground" ]