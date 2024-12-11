FROM php:8.2-fpm

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/html
COPY . .

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor libcap2-bin \
    libpng-dev libgmp-dev libzip-dev libicu-dev cron unixodbc-dev libxml2-dev libxslt1-dev libxslt-dev \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-get install -y default-mysql-client \
    && apt-get update

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install gmp \
    && docker-php-source delete

RUN git config --global --add safe.directory /var/www/html

RUN pecl install -o -f xdebug \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable xdebug

COPY --from=composer:2.6.6 /usr/bin/composer /usr/bin/composer

RUN groupadd --force -g ${GID} challenge
RUN useradd -ms /bin/bash --no-user-group -g ${GID} -u ${UID} challenge

RUN chown -R challenge:challenge /var/www/html

RUN sed -i "s/user = www-data/user = challenge/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = challenge/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm = dynamic/pm = static/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/pm.max_children = 5/pm.max_children = 23/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "pm.max_requests = 500" >> /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf
RUN echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/www.conf

RUN composer install --no-interaction && composer update --no-interaction