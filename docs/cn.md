# 国内网络问题

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* 从 `GitHub` 下载文件（docker-compose、composer）

> https://github.com/khs1994-website/github-chinese

* 官方默认的 `apt` 镜像

* `pecl`

* PHP `composer`

解决思路：

镜像构建尽可能使用 CI 服务器，国内云服务商均免费提供国外的容器构建环境。

在 `Dockerfile` 中，将 URL(国内访问慢的地址，例如 PHP 源码下载地址) 设置为 `ENV` 或 `ARG` 其默认值为官方地址。

本地测试（国内）时，使用 `Docker compose` 通过 `ARG` 将 URL 设为国内镜像地址。

具体参考本项目的 PHP compose 文件 https://github.com/khs1994-docker/lnmp/blob/master/dockerfile/php-fpm/docker-compose.yml
