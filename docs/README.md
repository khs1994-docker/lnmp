# khs1994-docker/lnmp 支持文档

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.org/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.org/khs1994-docker/lnmp) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp)

本项目不建议刚学习 LNMP 的新手使用，当掌握 LNMP 到一定程度时，相信你一定会与我产生共鸣：[项目初衷](why.md)。

本项目实际只是一个 PHP 程序的运行环境，PHP 项目文件位于 `./app/*`，nginx 配置文件位于 `./config/nginx/*.conf` 为 git 子模块，默认为空文件夹。

在线阅读：[GitHub](SUMMARY.md)

在线阅读：[WebSite](https://doc.lnmp.khs1994.com/)

或在命令行执行 `./lnmp-docker.sh docs` 在本地阅读。

# 为什么选择 Caas

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

# 赞赏我

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)。
