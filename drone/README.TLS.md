# 私有化 CI/CD 解决方案 (TLS)

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/ci.svg?style=social&label=Stars)](https://github.com/khs1994-docker/ci) [![star](https://gitee.com/khs1994-docker/ci/badge/star.svg?theme=dark)](https://gitee.com/khs1994-docker/ci/stargazers)

* [支持文档](docs)

* [问题反馈](https://github.com/khs1994-docker/ci/issues)

* [更多信息](https://www.khs1994.com/categories/CI/Drone/)

## 内部端口

* `Gogs` **3000** **22**

* `Drone` **8000**

* `Docker Registry` **5000**

## 准备

* 域名 (花生壳也行)

* 公网 IP (花生壳也行)

* 设置 DNS 解析，或内网 DNS 服务器

* `*.t.khs1994.com` 通配符 TLS 证书 （acme.sh 可以免费申请）

## 快速开始

### 初始化

首次使用本项目时，务必执行以下命令完成初始化。

```bash
$ ./ci
```

### 编辑 `.env` 文件

* `CI_HOST` 为主机 IP (建议使用内网 IP, 例如 192.168.199.100)

* `CI_DOMAIN` 为服务主域名（example t.khs1994.com）

* Windows 用户请将 `COMPOSE_CONVERT_WINDOWS_PATHS=1` 取消注释

### `443` 端口是否占用

根据 `443` 端口是否占用情况，使用下面的命令启动 CI `服务`。

* 已占用->实体机运行 NGINX

  ```bash
  $ ./ci up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX (`--use-external-nginx` 后边的路径为 NGINX 配置文件所在路径，必须为绝对路径，下同)

* 已占用->容器运行 NGINX

  ```bash
  $ ./ci up-tls --use-external-nginx=/etc/nginx/conf.d
  ```

  重启 NGINX 容器

* 未占用

  ```bash
  $ ./ci up-tls [-d] [--reset]
  ```
