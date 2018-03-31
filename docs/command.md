# PHPer 常用命令容器化

* `composer` => `lnmp-composer`
* `phpunit`  => `lnmp-phpunit`
* `php CLI`  => `lnmp-php`
* `laravel`  => `lnmp-laravel`
* `lnmp-laravel5.5`

> 为避免与原始命令冲突，这里加上了 `lnmp-` 前缀

## APP_ENV

`APP_ENV` 值为 `development`

## 使用方法

### 安装

自行将下面示例中的 `/data/lnmp` 替换为本项目实际路径。

#### Bash

```bash
$ vi ~/.bash_profile

export LNMP_PATH=/data/lnmp

export PATH=$LNMP_PATH:$LNMP_PATH/bin:$PATH
```

#### fish

```bash
$ vi ~/.config/fish/config.fish

set -gx LNMP_PATH /data/lnmp

set -gx fish_user_paths $fish_user_paths $LNMP_PATH $LNMP_PATH/bin
```

#### Windows 10

打开 `PowerShell`

```bash
$ [environment]::SetEnvironmentvariable("LNMP_PATH", "$HOME\lnmp", "User")

$ [environment]::SetEnvironmentvariable("Path", "$env:path;$env:LNMP_PATH;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl", "User")
```

> 如果 `PoswerShell` 禁止执行脚本，请以管理员身份执行 `set-ExecutionPolicy RemoteSigned`,之后输入 `Y` 确认。

### 使用

```bash
$ cd my_php_project

$ lnmp-composer command

$ lnmp-phpunit command

$ lnmp-php command

$ lnmp-laravel command # Laravel 5.6

$ lnmp-laravel5.5 command # Laravel 5.5
```

### 最佳实践

#### 新建 `Laravel` 项目

```bash
$ cd app

$ lnmp-laravel new my_laravel_app
```

#### `Laravel` 项目预览

```bash
$ cd my_laravel_app

$ lnmp-php -S 0.0.0.0:80 -t public
```

#### `artisan` command

```bash
$ cd my_laravel_app

$ lnmp-php artisan
```

#### 安装/升级 `composer` 依赖

```bash
$ cd my_laravel_app

$ lnmp-composer [install | update]
```
