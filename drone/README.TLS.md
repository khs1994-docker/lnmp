# 私有化 CI/CD 解决方案 (TLS)

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci) [![star](https://gitee.com/khs1994-docker/ci/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/ci/stargazers)

* [支持文档](docs)

* [问题反馈](https://github.com/khs1994-docker/ci/issues)

## 重要提示

本项目基于 [Drone `2.x`](https://docs.drone.io/) 版本。

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## 内部端口

* `Gogs` **3000** **22**

* `Drone` **8000**

* `Docker Registry` **5000**

## 准备

* 域名

* 公网 IP (推荐，但不是必须)

* `*.CI_DOMAIN` 通配符 TLS 证书 （acme.sh 可以免费申请）或 `git.CI_DOMAIN` `drone.CI_DOMAIN` 网址的 TLS 证书。

## 快速开始

### 初始化

首次使用本项目时，务必执行以下命令完成初始化。

```bash
$ ./ci
```

### 编辑 `.env` 文件

* `CI_HOST` 为主机 IP (建议使用内网 IP, 例如 `192.168.199.100`)

* `CI_DOMAIN` 为服务主域名（例如 `t.khs1994.com`）

### 安全

在 `.env` 文件中配置如下两个变量

* `DRONE_USER_CREATE` Drone 启动时创建的用户
* `DRONE_USER_FILTER` Drone 允许哪些用户注册，留空即表示允许所有用户注册，将会造成资源浪费，**强烈建议** 配置该选项

### 使用 khs1994-docker/lnmp 的 MySQL Redis NGINX 服务(可选项)

修改 `.env` 中的 `CI_INCLUDE` 变量，若 git 使用 Gogs 则只保留 `gogs` 即可，若使用 GitHub，请留空 `CI_INCLUDE=""`。

```bash
CI_INCLUDE="gogs"
```

并按如下内容修改 `.env` 文件

```bash
# CI_GIT_TYPE=gogs

CI_GIT_TYPE=github
```

> 启动之前必须先启动 khs1994-docker/lnmp

```bash
$ ./ci up-tls --config
```

检查 `docker-compose.yml` 配置是否正确，之后启动

```bash
$ ./ci up-tls
```

将生成的 NGINX 配置移入 `khs1994-docker/lnmp` 项目的 NGINX 配置目录

`config/nginx/drone.conf` `config/nginx/gogs.conf`

自行调整 SSL 相关配置。

将 SSL 证书移入 khs1994-docker/lnmp 项目的 NGINX 配置目录的 `ssl` 文件夹内。

注意 SSL 证书文件名必须与 NGINX 配置一致。

NGINX 配置好之后，重启 `khs1994-docker/lnmp`

```bash
$ ./lnmp-docker restart nginx
```

### `443` 端口是否占用

> 若使用 khs1994-docker/lnmp 的 NGINX 服务，请忽略此节。

根据 `443` 端口是否占用情况，使用下面的命令启动 CI `服务`。

* 已占用->实体机运行 NGINX

  ```bash
  $ ./ci up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX (`--use-external-nginx` 后边的路径为 NGINX 配置文件所在路径，必须为绝对路径)

* 已占用->容器运行 NGINX

  ```bash
  $ ./ci up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX 容器

* 未占用

  编辑 `.env` 文件

  ```bash
  CI_INCLUDE="gogs nginx redis mysql"
  ```

  ```bash
  $ ./ci up-tls [-d] [--reset]
  ```

## 访问测试

假设 `CI_DOMAIN` 设置为 `t.khs1994.com`

则 Drone 访问地址为 `https://drone.t.khs1994.com`,Gogs 访问地址为 `https://git.t.khs1994.com`

## 错误排查

进入 `logs` 文件夹内，查看日志文件排错。
