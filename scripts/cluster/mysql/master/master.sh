#!/usr/bin/env bash

set -ex

env

# MYSQL_ROOT_PASSWORD=$(cat ${MYSQL_ROOT_PASSWORD_FILE})

MYSQL_REPLICATION_PASSWORD=$(cat ${MYSQL_REPLICATION_PASSWORD_FILE})

# @link https://dev.mysql.com/doc/refman/8.0/en/environment-variables.html

export MYSQL_PWD=${MYSQL_ROOT_PASSWORD}

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# new user

mysql -u root \
-e "CREATE USER 'master'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; \
GRANT ALL ON *.* TO 'master'@'%' WITH GRANT OPTION;"

# create replication user

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

mysql -u root \
-e "CREATE USER '${MYSQL_REPLICATION_USER:-replication}'@'172.28.0.%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_REPLICATION_PASSWORD}'; \
GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER:-replication}'@'172.28.0.%'; "
