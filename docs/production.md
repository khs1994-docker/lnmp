# 配置

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

假设我们在 `开发环境` 中已经将 PHP 项目测试完毕，并推送到了 `GitHub`，准备在生产环境部署。

# 生产环境注意事项

在生产环境中建议使用 `Docker Swarm mode` 或 `k8s`。

本项目生产环境目标是超大规模 Docker 集群。

## 单机

单机环境中通过 `数据卷` 将 `项目文件` 挂载到容器中。

将 GitHub 上的 PHP 项目克隆到 `./app` 目录下，之后使用`lnmp-composer ...` 安装依赖。

在 `./config/nginx/*.conf` 增加 nginx 配置。

执行 `./lnmp-docker swarm-deploy`。

## 集群

直接将 PHP 项目打入镜像，以容器方式 (`Dockerfile`) 交付。

## PHP

* 生产环境不启用 `xdebug` 扩展

## phpMyAdmin

生产环境默认不启用该软件。

## Docker 私有仓库

Docker 镜像分发可以使用 Docker 私有仓库。

>注意这里为了表述方便将 git 统一称为 GitHub，实际项目可能不开源，会推送到私有 git 仓库中，请读者悉知。
