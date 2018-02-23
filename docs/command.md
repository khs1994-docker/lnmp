# PHPer 常用命令容器化

* `composer` => `lnmp-composer`
* `phpunit`  => `lnmp-phpunit`
* `php CLI`  => `lnmp-php`

## 使用方法

### 安装

```bash
$ vi /etc/profile

export PATH=/data/lnmp/bin:$PATH
```

### 使用

```bash
$ cd my_php_project

$ lnmp-composer command

$ lnmp-phpunit command

$ lnmp-php command
```
