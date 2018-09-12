# khs1994-docker/lnmp 支持文档

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

本项目不建议刚学习 LNMP 的新手使用，当掌握 LNMP 到一定程度时，相信你一定会与我产生共鸣：[项目初衷](why.md)。

本项目实际只是一个 PHP 程序的运行环境，PHP 项目文件位于 `./app/*`，nginx 配置文件位于 `./config/nginx/*.conf` 为 git 子模块，默认为空文件夹。

在线阅读：[GitHub](SUMMARY.md)

在线阅读：[WebSite](https://doc.lnmp.khs1994.com/)

或在命令行执行 `./lnmp-docker.sh docs` 在本地阅读。

# 版本策略

`vYY.MM` 分支与 Docker Stable 版本 `vYY.MM` 一致，每当 PHP 主线版本升级时，修正版本号加 1。

例如：当 Docker 桌面版发布 `v18.09` 时，本项目将从 `master` 分支检出 `18.09` 分支，PHP 发布 7.2.10 时，本项目将发布 `v18.09` 版本，PHP 发布 7.2.11 时，本项目将发布 `v18.09.01` 版本，当大部分 PHP 扩展兼容 PHP 7.3.0 时，本项目会将 PHP 版本由 7.2 切换到 7.3

# 为什么选择 CaaS

* 分钟级上线

* 分钟级迁移

# 满足 LNMP 开发全部需求

* 各组件（软件）多版本支持

* 快速新建 `PHP` 项目

* 快速生成 `nginx` 配置

* 一键申请 `SSL` 证书

* 一键生成 `SSL` 自签名证书用于开发、测试环境

* 支持 `开发环境` `测试环境`

* 支持 `Swarm mode` `k8s` `生产环境` 部署

* 支持一键启动 `MySQL` `Redis` `Memcached` 集群

* 所有软件尽可能启用了 **TLS** **HTTPS**，为推动 **HTTPS** 普及贡献自己的力量

# 系列文章

* [完全使用 Docker 开发 PHP 项目 （一）: 安装篇](https://segmentfault.com/a/1190000013364203)

* [完全使用 Docker 开发 PHP 项目 （二）: 配置篇](https://segmentfault.com/a/1190000013364300)

* [完全使用 Docker 开发 PHP 项目 （三）: 命令容器化](https://segmentfault.com/a/1190000013364609)

* [完全使用 Docker 开发 PHP 项目 （四）: CLI](https://segmentfault.com/a/1190000013364774)

* [完全使用 Docker 开发 PHP 项目 （五）: 生产环境 Swarm mode](https://segmentfault.com/a/1190000013484870)

* [完全使用 Docker 开发 PHP 项目 （六）: 生产环境 Kubernetes](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （七）: Redis 主从复制](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （八）: Redis 集群](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （九）: Mysql 一主两从集群](https://segmentfault.com/a/)

# 捐赠

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)。

# 云容器服务推广

* [腾讯云容器服务](http://dwz.cn/I2vYahwq)
