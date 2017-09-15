# Laravel

## 新建 Laravel 项目

修改 `.env` 文件

例如 Laravel 项目位于 `./app/blog`，`.env`配置如下

```bash
# laravel 路径

LARAVEL_APP_NAME=blog
```

不建议使用 `-d` 参数，前台执行便于排错

```bash
$ docker-compose -f docker-compose.laravel.install.yml up && docker-compose -f docker-compose.laravel.install.yml down
```

已将缓存引出，后续执行将使用缓存

## artisan

```bash
$ docker run --rm -v $PWD/app/blog:/app lnmp-laravel-artisan help
```

## 安装 Laravel 依赖包

修改 `.env` 文件

例如 Laravel 项目位于 `./app/blog`，`.env`配置如下

```bash
# Composer 执行路径

COMPOSER_PATH=blog
```

```bash
$ docker-compose -f docker-compose.composer.yml up && docker-compose -f docker-compose.composer.yml down
```
