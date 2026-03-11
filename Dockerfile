FROM php:8.3-fpm-alpine

RUN apk add --no-cache git unzip libzip-dev oniguruma-dev icu-dev bash \
  && docker-php-ext-install pdo pdo_mysql bcmath intl

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN if [ -f composer.json ]; then \
      composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader; \
    fi

RUN if [ -f artisan ]; then \
      php artisan config:cache || true; \
      php artisan route:cache || true; \
      php artisan view:cache || true; \
    fi

EXPOSE 9000

CMD ["php-fpm", "-F"]
