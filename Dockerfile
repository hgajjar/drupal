FROM devwithlando/php:7.1-apache

ENV LANDO_WEBROOT=/app/.
ENV PORT 80
EXPOSE 80

WORKDIR /app
COPY . .