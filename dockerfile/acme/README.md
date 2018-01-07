# acme Docker

[![GitHub stars](https://img.shields.io/github/stars/khs1994-docker/acme.sh.svg?style=social&label=Stars)](https://github.com/khs1994-docker/acme.sh) [![GitHub tag](https://img.shields.io/github/tag/khs1994-docker/acme.sh.svg)](https://github.com/khs1994-docker/acme.sh) [![Docker Stars](https://img.shields.io/docker/stars/khs1994/acme.svg)](https://store.docker.com/community/images/khs1994/acme.sh) [![Docker Pulls](https://img.shields.io/docker/pulls/khs1994/acme.svg)](https://store.docker.com/community/images/khs1994/acme.sh)

# Supported tags and respective `Dockerfile` links

* [`2.7.5`, `alpine`, `latest` (alpine/Dockerfile)](https://github.com/khs1994-docker/acme.sh/blob/2.7.5/alpine/Dockerfile)

# Usage

>目前仅支持 `dnspod.cn` 和 `nginx` 服务器并且仅支持签发 `ecc` 证书。

```bash
$ cp .env.example .env

# 编辑 .env 文件

$ docker-compose up --no-build
```

# Who use it?

[khs1994-docker/lnmp](https://github.com/khs1994-docker/lnmp) use this Docker Image.
