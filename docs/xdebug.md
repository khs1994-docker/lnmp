# xdebug in Docker (PhpStorm)

## 准备 PHP 项目

* PHP 项目

* NGINX 配置

## 在 `IDE` 设置中配置 `Xdebug`

`Preferenences` -> `Languages & ...`-> `PHP` -> `Debug`-> `xdebug`-> `Debug port 9001`(默认为 `9000`，这里改为 `9001`)

> `9001` 端口务必与 `./config/php/php/conf.d/xdebug.ini` 一致。

该设置页 `Pre-configuration` 有简要的步骤。

## 浏览器扩展

* [火狐](https://github.com/BrianGilbert/xdebug-helper-for-firefox)

* [Chrome](https://github.com/mac-cain13/xdebug-helper-for-chrome)

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
