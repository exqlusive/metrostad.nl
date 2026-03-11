FROM dunglas/frankenphp:php8.3-alpine

WORKDIR /app

RUN install-php-extensions pdo_mysql bcmath intl opcache pcntl

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .

RUN if [ -f composer.json ]; then \
      composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader; \
    fi

RUN mkdir -p bootstrap/cache storage/framework/cache storage/framework/sessions storage/framework/views storage/logs \
  && chown -R www-data:www-data storage bootstrap/cache || true

RUN if [ -f artisan ]; then \
      php artisan config:cache || true; \
      php artisan route:cache || true; \
      php artisan view:cache || true; \
    fi

COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
