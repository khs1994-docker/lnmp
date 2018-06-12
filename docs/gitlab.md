# GitLab

**警告** GitLab 启动时间较长，请耐心等待！

* https://docs.gitlab.com/omnibus/docker/

## 启用

编辑 `.env` 文件中的如下变量，包含 gitlab

```bash
DEVELOPMENT_INCLUDE="nginx mysql php7 redis phpmyadmin gitlab"
```

Windows 用户请编辑 `.env.ps1` 文件中的如下变量，包含 gitlab

```bash
$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin','gitlab'
```

### .env 配置项

```bash
# 强烈建议使用 https

LNMP_GITLAB_HOST=
# LNMP_GITLAB_HOST=https://git.t.khs1994.com

# ssh 端口，考虑到本机 ssh-server 可能占用 22 ，本项目默认设置到 8022，
# 想使用 22 端口，先配置本机 ssh-server 端口到其他。再配置下边变量值为 22
LNMP_GITLAB_SSH_PORT=8022
```

## SSL 证书

> 证书需要自行申请！

将以下两个文件放到 `config/nginx/ssl` 目录中

```bash
host.crt

host.key

# git.t.khs1994.com.crt
# git.t.khs1994.com.key
```

## 配置 NGINX 反向代理

大部分情况 `GitLab` 与其他 `Web` 服务 (`NGINX`) 共存。

为了 git 地址的美观，不建议通过映射到其他端口号来避免与 NGINX 的 80 443 端口发生冲突。

所以需要配置反向代理。

```bash
$ cp config/nginx/demo-gitlab.config config/nginx/gitlab.conf

$ vi config/nginx/gitlab.conf

# 自行修改配置
```

# 启动

```bash
$ lnmp-docker.sh up
```

# 不再使用

* 在第一步中将 `.env` 文件中的相关变量中的 `gitlab` 除去，即第一步增加了什么，就去掉什么。

* 将 NGINX 配置文件 `gitlab.conf` 改名为 `gitlab.conf.back`
