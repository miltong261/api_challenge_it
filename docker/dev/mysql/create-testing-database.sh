#!/usr/bin/env bash

mysql --user=root --password="$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS challenge;
    GRANT ALL PRIVILEGES ON \`challenge%\`.* TO '$MYSQL_USER'@'%';
EOSQL
