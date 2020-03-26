# MySQL

## 默认密码

```bash
mytest
```

## 修改密码

修改 `.env` 文件

```diff
- LNMP_MYSQL_ROOT_PASSWORD=mytest
+ LNMP_MYSQL_ROOT_PASSWORD=newpassword

- LNMP_MYSQL_DATABASE=test
+ LNMP_MYSQL_DATABASE=mydb
```

> 如果 MySQL 之前启动过，则无法使用以上方法修改密码。要么销毁（数据卷）之后重新启动，要么手动进入命令行修改密码。
