# 备份恢复

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## MySQL 备份

```bash
$ mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} -R test > /backup/"$(date "+%Y%m%d-%H.%M.%S")".sql
```

## MySL 恢复

```bash
$ mysql -uroot -p{MYSQL_ROOT_PASSWORD} < /backup/default.sql
```

## More Information

* https://zhuanlan.zhihu.com/p/26129750
