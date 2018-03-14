#!/bin/bash

set -e

# MySQL Docker 8.0.4 based stretch(Debian 9) Remove ip ping etc command

# mysql_net=$(ip route | awk '$1=="default" {print $3}' | sed "s/\.[0-9]\+$/.%/g")

DB_ROOT_PASSWORD=$(cat /etc/mysql/db_root_password)

export MYSQL_PWD=${DB_ROOT_PASSWORD}

# check mysql master status

until mysql -umaster -h mysql_master ; do
  >&2 echo "MySQL master is unavailable - sleeping"
  sleep 3
done

echo "MySQL master is available"

# new only read user

mysql -u root \
-e "GRANT SELECT ON *.* TO 'node'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"

# new REPLICATION user

mysql -u root \
-e "GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER}'@'172.28.0.%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"

# 锁定数据库

mysql -uroot -h mysql_master -e "FLUSH TABLES WITH READ LOCK"

# 备份数据库

# mysqldump -u root -p${DB_ROOT_PASSWORD} --all-databases  --lock-tables=false  -- > /root/all.sql

# get master log File & Position

master_status_info=$(mysql -u root -h mysql_master -e "show master status\G")

# 解锁数据库

mysql -uroot -h mysql_master -e "UNLOCK TABLES"

# 解析值

LOG_FILE=$(echo "${master_status_info}" | awk 'NR!=1 && $1=="File:" {print $2}')

LOG_POS=$(echo "${master_status_info}" | awk 'NR!=1 && $1=="Position:" {print $2}')

# set node master

mysql -u root \
-e "CHANGE MASTER TO MASTER_HOST='mysql_master', \
MASTER_PORT=3306, \
MASTER_USER='${MYSQL_REPLICATION_USER}', \
MASTER_PASSWORD='${DB_ROOT_PASSWORD}', \
MASTER_LOG_FILE='${LOG_FILE}', \
MASTER_LOG_POS=${LOG_POS}"

# start slave and show slave status

mysql -u root -e "START SLAVE;show slave status\G"

# 主节点新建数据库

mysql -umaster -h mysql_master -e 'create database if not exists test'

# 从节点验证

mysql -unode -e 'show databases;'
