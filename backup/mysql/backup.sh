#!/bin/bash

mysql -uroot -p${MYSQL_ROOT_PASSWORD} test > /backup/"$(date "+%Y%m%d-%H.%M")".sql
