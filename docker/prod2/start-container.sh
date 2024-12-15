#!/bin/sh

# Clear and cache Laravel configuration
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# Start Supervisor
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf