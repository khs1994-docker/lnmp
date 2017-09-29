#!/bin/bash
RESTORE_DATABASES=test

mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /backup/*.sql
