# khs1994-docker/lnmp 支持文档

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/lnmp.svg?style=social&label=Stars)](https://github.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![Build Status](https://travis-ci.com/khs1994-docker/lnmp.svg?branch=master)](https://travis-ci.com/khs1994-docker/lnmp) [![GitHub release](https://img.shields.io/github/release/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp/releases) [![GitHub (pre-)release](https://img.shields.io/github/release/khs1994-docker/lnmp/all.svg)](https://github.com/khs1994-docker/lnmp/releases) [![license](https://img.shields.io/github/license/khs1994-docker/lnmp.svg)](https://github.com/khs1994-docker/lnmp) [![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

本项目不建议刚学习 LNMP 的新手使用，当掌握 LNMP 到一定程度时，相信你一定会与笔者产生共鸣：[项目初衷](why.md)。

在线阅读：[GitHub](SUMMARY.md)

在线阅读：[WebSite](https://docs.lnmp.khs1994.com/)

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## 版本策略

为了更好的实践 `git flow`，本项目将使用多分支进行开发。

`YY.MM` 分支与 Docker Stable 版本 `vYY.MM` 一致，每当 PHP 主线版本升级时，修正版本号加 1。

例如：当 Docker 桌面版发布 `v18.09` 时，本项目将从 `master` 分支检出 `18.09` 分支，PHP 发布 7.2.13 时，本项目将发布 `v18.09.0` 版本，PHP 发布 7.2.14 时，本项目将发布 `v18.09.01` 版本，当大部分 PHP 扩展兼容 PHP 7.3.x 时，本项目会将 PHP 版本由 7.2 切换到 7.3

即：本项目 `v18.09.0` 与 **Docker 桌面版** `v18.09` 和 **PHP** `7.2.13` 对应。

发布流程：
* PHP 发布新版本时(PHP 7.3.9)，打 `tag`，归档当前项目(PHP 7.3.8)，发布正式版本(7.3.8)
* 更新 PHP Dockerfile(PHP 7.3.9)，推送到 `YY.MM-pre` 分支，CI 自动同步 PHP Dockerfile 到 `khs1994-docker/php`
* `khs1994-docker/php` 打 `tag`(PHP 7.3.9)
* CI 构建 PHP 镜像(PHP 7.3.9)，构建完成之后合并到 `YY.MM` 分支，发布 `alpha` 版本(PHP 7.3.9)
* 后续根据开发流程，发布 `beta` `rc` 版本(PHP 7.3.9)
* 期间更新 PHP Dockerfile (PHP 7.3.9)时，`khs1994-docker/php` 可以打多个 tag (**7.3.9-1** **7.3.9-2**)

## 特色

* 各组件（软件）多版本支持

* 快速新建 `PHP` 项目

* 快速生成 `nginx` 配置

* 一键申请 `SSL` 证书

* 一键生成 `SSL` 自签名证书用于开发、测试环境

* 支持 **开发环境** **测试环境**

* 支持 `kubernetes` **生产环境** 部署

* 支持一键启动 `MySQL` `Redis` `Memcached` 集群

* 所有软件尽可能启用了 **TLS** **HTTPS**

* 内置 `Drone CI` 私有 CI/CD 方案

* [可扩展](custom.md)，支持自定义 `docker compose` 文件

* 通过 [khs1994-docker/actions-setup-lnmp](https://github.com/khs1994-docker/actions-setup-lnmp) 可在 GitHub Actions CI/CD 中快速启用 LNMP 环境

## 系列文章

* [完全使用 Docker 开发 PHP 项目 （一）: 安装篇](https://segmentfault.com/a/1190000013364203)

* [完全使用 Docker 开发 PHP 项目 （二）: 配置篇](https://segmentfault.com/a/1190000013364300)

* [完全使用 Docker 开发 PHP 项目 （三）: 命令容器化](https://segmentfault.com/a/1190000013364609)

* [完全使用 Docker 开发 PHP 项目 （四）: CLI](https://segmentfault.com/a/1190000013364774)

* [完全使用 Docker 开发 PHP 项目 （五）: 生产环境 Swarm mode](https://segmentfault.com/a/1190000013484870)

* [完全使用 Docker 开发 PHP 项目 （六）: 生产环境 Kubernetes](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （七）: Redis 主从复制](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （八）: Redis 集群](https://segmentfault.com/a/)

* [完全使用 Docker 开发 PHP 项目 （九）: Mysql 一主两从集群](https://segmentfault.com/a/)

## 捐赠

请访问 [https://zan.khs1994.com](https://zan.khs1994.com)

## 腾讯云容器服务 Kubernetes

如果您的企业有使用 `Kubernetes` 的需求，欢迎使用 [腾讯云容器服务](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)。
