#!/bin/bash

set -ex

DB_ROOT_PASSWORD=$(cat /etc/mysql/db_root_password)

export MYSQL_PWD=${DB_ROOT_PASSWORD}

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# new user

mysql -u root \
-e "CREATE USER 'master'@'%' IDENTIFIED WITH mysql_native_password BY '${DB_ROOT_PASSWORD}'; \
GRANT ALL ON *.* TO 'master'@'%' WITH GRANT OPTION;"

# create replication user

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

mysql -u root \
-e "CREATE USER '${MYSQL_REPLICATION_USER}'@'172.28.0.%' WITH mysql_native_password BY '${DB_ROOT_PASSWORD}'; \
GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER}'@'172.28.0.%'; "
