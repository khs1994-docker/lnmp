# MySQL 复制

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* 一主两从 主负责写，两从负责读

* 多主一从 （多源复制）

## 开发环境

```bash
# 创建集群，若加上 -d 参数表示后台运行。

$ ./lnmp-docker clusterkit-mysql-up [-d]

# 销毁集群，若加上 -v 参数会销毁数据卷。

$ ./lnmp-docker clusterkit-mysql-down [-v]
```

### Swarm mode

```bash
# 创建集群

$ ./lnmp-docker clusterkit-mysql-deploy

# 销毁集群

$ ./lnmp-docker clusterkit-mysql-remove
```

# PHP 连接集群

主服务器 `root` 账号

从服务器 `node` 账号（拥有只读权限）

## Laravel

```php
'mysql' => [
    'read' => [
        'host' => '192.168.1.1',
        'port' => '3306',
    ],
    'write' => [
        'host' => '196.168.1.2',
        'port' => '3306'
    ],
    'sticky'    => true,
    'driver'    => 'mysql',
    'database'  => 'database',
    'username'  => 'root',
    'password'  => '',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix'    => '',
],
```

```php
$users = DB::connection('foo')->select(...);
```
