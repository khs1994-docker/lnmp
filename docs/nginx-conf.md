# 一键生成 nginx 配置

## 生成 http 配置

命令格式为

```bash
$ ./lnmp-docker.sh nginx-conf http 路径 url
```

示例如下

```bash
$ ./lnmp-docker.sh nginx-conf http test www.khs1994.com
```

>注意，执行命令之后请到 `config/nginx/url.conf` 检查配置文件，之后再执行 `./lnmp-docker.sh restart nginx` 重启 nginx。

开发、测试环境可能需要修改 `/etc/hosts`。

## 生成 https 配置

生成 https 配置之前请确保拥有 ssl 证书，你可以查看 [下一小节](nginx-with-https.md) 获取证书。

命令格式为

```bash
$ ./lnmp-docker.sh nginx-conf https 路径 url
```

示例如下

```bash
$ ./lnmp-docker.sh nginx-conf https test www.khs1994.com
```

>注意，执行命令之后请到 `config/nginx/url.conf` 检查配置文件，之后再执行 `./lnmp-docker.sh restart nginx` 重启 nginx。

开发、测试环境可能需要修改 `/etc/hosts`。
