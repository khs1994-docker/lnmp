Changelog
==============
#### v17.09 rc4

* 编写支持文档
* 优化 Dockerfile

#### v17.09 rc3

* 编写交互式命令行工具（CLI）`docker-lnmp.sh` ，一切操作均可使用 CLI 完成
* 优化 Dockerfile ,针对国内时区、网络等进行深度优化
* 增加由 `Travis CI` 支持的项目自动化测试

#### v17.09 rc2

* 增加 `生产环境` 配置
* 增加：Composer
* 增加：Laravel
* 增加：Laravel artisan
* 以下增加软件默认注释，请按需开启
* 增加：MongoDB
* 增加：Memcached
* 增加：RabbitMQ
* 增加：PostgreSQL

#### v17.09 rc1

* 完成 Nginx、MySQL、Redis、PHP 集成
* 改时区（基于官方 Dockerfile 重新构建镜像）
* 挂载`项目`文件
* 挂载`配置`文件
* 挂载`日志`文件
* 挂载`数据`文件
* 尽可能做到新机（提前安装配置好 Docker）一键部署 LNMP 开发环境
* 测试 PhpStorm xdebug 远程调试
