#!/usr/bin/env bash

set -ex

# 复制模式
# 一主多从
# 多主一从 （多源复制）

# @see https://www.cnblogs.com/zhanmeiliang/p/5911558.html
# @see https://www.cnblogs.com/xuanzhi201111/p/5151666.html

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

env

# MYSQL_ROOT_PASSWORD=$(cat ${MYSQL_ROOT_PASSWORD_FILE})

MYSQL_REPLICATION_PASSWORD=$(cat ${MYSQL_REPLICATION_PASSWORD_FILE})

# @link https://dev.mysql.com/doc/refman/8.0/en/environment-variables.html

export MYSQL_PWD=${MYSQL_ROOT_PASSWORD}

# check mysql master status

until mysql -umaster -h mysql_master-1 ; do
  >&2 echo "MySQL master is unavailable - sleeping"
  sleep 3
done

echo "MySQL master is available"

# new only read user

mysql -u root \
-e "CREATE USER 'node'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; \
GRANT SELECT ON *.* TO 'node'@'%';"

# new REPLICATION user

# mysql -u root \
# -e "CREATE USER '${MYSQL_REPLICATION_USER:-replication}'@'172.28.0.%' WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; \
# GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER：-replication}'@'172.28.0.%';"

# lock database

mysql -uroot -h mysql_master-1 -e "FLUSH TABLES WITH READ LOCK"

# backup database

# mysqldump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases  --lock-tables=false  -- > /root/all.sql

# get master log File & Position

master_status_info=$(mysql -u root -h mysql_master-1 -e "show master status\G")

# unlock database

mysql -uroot -h mysql_master-1 -e "UNLOCK TABLES"

# 解析值

LOG_FILE=$(echo "${master_status_info}" | awk 'NR!=1 && $1=="File:" {print $2}')

LOG_POS=$(echo "${master_status_info}" | awk 'NR!=1 && $1=="Position:" {print $2}')

# set node master

mysql -u root \
-e "CHANGE MASTER TO MASTER_HOST='mysql_master-1', \
MASTER_PORT=3306, \
MASTER_USER='${MYSQL_REPLICATION_USER}', \
MASTER_PASSWORD='${MYSQL_REPLICATION_PASSWORD}', \
MASTER_LOG_FILE='${LOG_FILE}', \
MASTER_LOG_POS=${LOG_POS}"

# 多源复制

# mysql -u root \
# -e "CHANGE MASTER TO MASTER_HOST='mysql_master-1', \
# MASTER_PORT=3306, \
# MASTER_USER='${MYSQL_REPLICATION_USER}', \
# MASTER_PASSWORD='${MYSQL_REPLICATION_PASSWORD}', \
# MASTER_LOG_FILE='${LOG_FILE}', \
# MASTER_LOG_POS=${LOG_POS}, \ MASTER_AUTO_POSITION=1,
# FOR CHANNEL 'master-1'"

# mysql -u root \
# -e "CHANGE MASTER TO MASTER_HOST='mysql_master-2', \
# MASTER_PORT=3306, \
# MASTER_USER='${MYSQL_REPLICATION_USER}', \
# MASTER_PASSWORD='${MYSQL_REPLICATION_PASSWORD}', \
# MASTER_LOG_FILE='${LOG_FILE}', \
# MASTER_LOG_POS=${LOG_POS}, \ MASTER_AUTO_POSITION=1,
# FOR CHANNEL 'master-2'"

# start slave and show slave status

mysql -u root -e "START SLAVE;show slave status\G"

# 多源复制
# mysql -u root -e "START SLAVE FOR channel='master-1';show slave status\G"
# mysql -u root -e "START SLAVE FOR channel='master-2';show slave status\G"

# verify

# master new database

mysql -umaster -h mysql_master-1 -e 'create database if not exists test'

# node see database

mysql -unode -e 'show databases;'
