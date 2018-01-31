# Laravel

## 新建 Laravel 项目

```bash
$ ./lnmp-docker.sh laravel 路径
```

例如路径输入 `test`，相当于在 `./app/` 执行 `laravel new test`。

```bash
$ ./lnmp-docker.sh laravel test
```

## artisan

```bash
$ ./lnmp-docker.sh laravel-artisan 路径 命令
```

例如路径输入 `test`，命令输入 `--version`，相当于在 `./app/test/` 执行 `php artisan --version`

```bash
$ ./lnmp-docker.sh laravel-artisan test --version
```

### artisan 参数列表

```bash
$ ./lnmp-docker.sh laravel-artisan 路径 list
```

## 安装升级 Laravel 依赖包

```bash
$ ./lnmp-docker.sh composer 路径 命令 包名
```

例如要在 `./app/test` 中安装 `khs1994/curl` 包，可以执行如下命令

```bash
$ ./lnmp-docker.sh composer test require khs1994/curl @dev
```
