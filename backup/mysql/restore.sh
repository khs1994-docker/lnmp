#!/bin/bash

mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /backup/*.sql
