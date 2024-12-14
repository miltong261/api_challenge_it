#!/bin/sh

cd /var/www

php artisan optimize
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan event:cache
php artisan storage:link

chmod -R 0777 storage
chmod -R 0777 storage/logs/laravel.log
chmod -R 0777 storage/logs/laravel.log

#/usr/bin/supervisord -c /etc/supervisord.conf
# Al final de run.sh
exec php-fpm
