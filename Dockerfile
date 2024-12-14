FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Add docker php ext repo
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Apt update and deps
RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor libcap2-bin \
    libpng-dev libgmp-dev libzip-dev libicu-dev cron unixodbc-dev libxml2-dev libxslt1-dev libxslt-dev \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-get update

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential locales \
    libmemcached-dev \
    nginx \
    lsof

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) pdo_mysql exif pcntl bcmath gd mysqli pcntl zip intl gmp \
    && docker-php-ext-configure gd \
    && docker-php-source delete

COPY --from=composer:2.6.6 /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# add root to www group
RUN chmod -R ug+w /var/www/storage && chmod -R 0777 storage . -R

# Copy nginx/php/supervisor configs
RUN cp docker/prod/php.ini /usr/local/etc/php/conf.d/app.ini
RUN cp docker/prod/nginx/default.conf /etc/nginx/sites-enabled/default

# PHP-FPM configs
RUN sed -i "s/pm = dynamic/pm = static/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm.max_children = 5/pm.max_children = 23/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "pm.max_requests = 500" >> /usr/local/etc/php-fpm.d/www.conf

# PHP Error Log Files
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer install --optimize-autoloader --no-dev
RUN chmod +x /var/www/docker/prod/run.sh

EXPOSE 80
ENTRYPOINT ["/var/www/docker/prod/run.sh"]