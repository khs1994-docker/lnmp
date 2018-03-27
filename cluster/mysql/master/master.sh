#!/bin/bash

set -ex

DB_ROOT_PASSWORD=$(cat /etc/mysql/db_root_password)

export MYSQL_PWD=${DB_ROOT_PASSWORD}

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# new user

mysql -u root \
-e "GRANT ALL PRIVILEGES ON *.* TO 'master'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}' WITH GRANT OPTION;"

# create replication user

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

mysql -u root \
-e "GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER}'@'172.28.0.%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
