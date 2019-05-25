# PHP 项目文件夹

访问 `http://127.0.0.1/demo.html` 测试各组件功能。

PHP 项目放入此文件夹中，一个项目一个文件夹。

## `APP_ENV` 值的说明

我们知道 `APP_ENV` 的值影响着 `Laravel` 所加载的 `.env.*` 文件

例如 `APP_ENV` 值为 `development`，那么 `Laravel` 就会加载 `.env.development` 文件

* `development` Docker 容器开发环境，例如 `Docker Desktop`

* `production` Docker 生产环境

* `wsl` `macos` `windows` `linux` 环境为完全没用到 Docker 的情况，各自对应着系统种类。
