# 备份

## MySQL 备份

```bash
mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} -R test > /backup/"$(date "+%Y%m%d-%H.%M")".sql
```

## MySL 恢复

```bash
mysql -uroot -p{MYSQL_ROOT_PASSWORD} test < /backup/default.sql
```
