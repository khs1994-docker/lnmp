mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'"
