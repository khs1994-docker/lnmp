# SUMMARY

* [LNMP Docker 支持文档](README.md)
* [项目初衷](why.md)
* [安装配置 Docker](docker.md)

## 安装

* 安装
    * [Linux macOS](install/linux.md)
    * [Windows 10](install/windows.md)
* [项目初始化过程](init.md)
* [路径说明](path.md)
* [`lnmp-docker`](cli.md)
* 开发环境
    * [使用方法](development.md)

## NGINX

* [NGINX](nginx/README.md)
    * [一键生成配置](nginx/config.md)
    * [申请或自签发 SSL 证书](nginx/issue-ssl.md)
    * [HTTPS 配置](nginx/https.md)
    * [NGINX Unit](nginx/unit.md)
* [PHPer 常用命令容器化](command.md)
* [软件配置](config.md)
* [Crontab](crontab.md)

## PHP

* PHP
    * [PHP 扩展列表](php.md)
    * [Xdebug](xdebug.md)
    * [Laravel](laravel.md)
    * [Composer](composer.md)
    * [PHPUnit](phpunit.md)

* Composer
    * [Satis](composer/satis.md)

## 生产环境

* [生产环境(重要)](production.md)
    * [Swarm mode](swarm/README.md)
    * [Kubernetes](kubernetes/README.md)
        * [k8s on Docker for Desktop](kubernetes/docker-desktop.md)
    * [Docker Registry](registry.md)

## ClusterKit

* [ClusterKit](clusterkit/README.md)
    * [MySQL 一主两从](clusterkit/mysql.md)
    * [Memcached 集群](clusterkit/memcached.md)
    * [Redis Cluster ](clusterkit/redis_cluster.md)
    * [Redis Master slave](clusterkit/redis_master_slave.md)
    * [Redis Sentinel](clusterkit/redis_sentinel.md)
* 树莓派3
    * [ARM架构](arm.md)
* [systemd](systemd.md)
* [备份恢复](backup.md)
* [清理](cleanup.md)
* [国内网络问题](cn.md)
* 实验玩法
    * [LinuxKit](linuxkit.md)
* [微信小程序 PHP 后端部署](wechat.md)

## Volumes

* Volumes
    * [NFS](volumes/nfs.md)

## 对象存储

* [Minio](minio.md)

## 测试

* [ab command](ab.md)
