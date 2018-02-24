# PHPer 常用命令容器化

* `composer` => `lnmp-composer`
* `phpunit`  => `lnmp-phpunit`
* `php CLI`  => `lnmp-php`

> 为避免与原始命令冲突，这里加上了 `lnmp-` 前缀

## 使用方法

### 安装

自行将下面示例中的 `/data/lnmp` 替换为本项目实际路径。

#### Bash

```bash
$ vi /etc/profile

export PATH=/data/lnmp/bin:$PATH
```

#### fish

```bash
$ vi vi ~/.config/fish/config.fish

set -gx fish_user_paths $fish_user_paths /data/lnmp/bin
```

### 使用

```bash
$ cd my_php_project

$ lnmp-composer command

$ lnmp-phpunit command

$ lnmp-php command
```

### 最佳实践

#### `Laravel` 项目预览

```bash
$ cd laravel_app

$ lnmp-php -S 0.0.0.0:80 -t public
```

#### `artisan` command

```bash
$ cd laravel_app

$ lnmp-php artisan
```
