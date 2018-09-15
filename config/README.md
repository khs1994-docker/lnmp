# 配置文件

## 生产环境配置文件

`*/*.production.*`

## 最佳实践

### 开发环境

一个 **项目** 一个 **网址** 一个 `NGINX` 或 `APACHE` 配置文件。

通过 `Volumes` 挂载到容器中。

### 生产环境

一个 **主域名** 一个 **配置文件** 一个 **TLS 密钥** 一个 **TLS 证书**（Let's Encrypt 支持签发免费的 [通配符](https://github.com/khs1994-docker/lnmp/blob/master/docs/issue-ssl.md) 证书）。

通过 [`Secrets`](https://docs.docker.com/engine/swarm/secrets/) [`Configs`](https://docs.docker.com/engine/swarm/configs/) 统一挂载到集群中。

## 项目贡献者

更新默认配置文件

```bash
$ ./default.sh

# Windows
# docker setting open 127.0.0.1:2375
$ wsl
# set DOCKER_HOST=tcp://127.0.0.1:2375
$ ./default.sh
```
