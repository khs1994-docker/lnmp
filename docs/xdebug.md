# 本项目使用 Xdebug in Docker + PhpStorm 最佳实践

## 准备 PHP 项目

* PHP 项目

* NGINX 配置

* 验证浏览器能通过网址访问到你的项目

## 设置 Xdebug

配置文件路径 `./config/php/php/conf.d/xdebug.ini`

> 这里仍以示例配置为例，如何正确的自定义配置请查看 [这里](config.md)

### 调试 HOST (必选项)

`xdebug.remote_host=192.168.199.100` 将 `192.168.199.100` 替换为你自己的 IP。这就要求你的电脑必须固定 IP。不然电脑 IP 每次变化时，必须重新修改配置文件。

在 Docker 没有配置 DNS 的情况下可以使用下面的配置

`xdebug.remote_host=host.docker.internal`

所以有以下几种情况

* Docker 没有配置 DNS 建议使用第二种配置方法

* 电脑拥有固定 IP，采用第一种方法，但由于网络环境（家、公司）不定，每次还是得修改 Xdebug 设置里的 IP

* 电脑 IP 不定，又想自定义 Docker DNS 配置，那就只能每次 IP 变化时重新修改 xdebug 设置里的 IP

### 调试端口（可选项）

`xdebug.remote_port=9001`

### 警告

其他选项严禁修改，除非你明确知道某个选项将产生什么影响。

## 重启容器

```bash
$ ./lnmp-docker.sh restart php7
```

## 在 `IDE` 设置中配置 `Xdebug`

`Preferenences` -> `Languages & ...`-> `PHP` -> `Debug`-> `xdebug`-> `Debug port 9001`(默认为 `9000`，这里改为 `9001`)

> `9001` 端口务必与 `./config/php/php/conf.d/xdebug.ini` 一致。

该设置页 `Pre-configuration` 有简要的步骤。

## 浏览器扩展

* [火狐](https://github.com/BrianGilbert/xdebug-helper-for-firefox)

* [Chrome](https://github.com/mac-cain13/xdebug-helper-for-chrome)

### 设置扩展

在扩展配置中 IDE key 选择 PhpStorm

## IDE 中点击工具栏电话图标

## 编写代码

## 打断点

## 浏览器刷新对应页面

在调试页面点击扩展图标，选择 `debug`，之后刷新页面

## 自动跳转到 IDE

## More Information

* https://xdebug.org/docs/remote

* https://segmentfault.com/a/1190000010833434

* https://confluence.jetbrains.com/display/PhpStorm/Docker+Support+in+PhpStorm
