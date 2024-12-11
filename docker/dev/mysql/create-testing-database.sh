#!/usr/bin/env bash

mysql --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS payment_service;
    GRANT ALL PRIVILEGES ON \`payment_service%\`.* TO '$MYSQL_USER'@'%';
EOSQL
