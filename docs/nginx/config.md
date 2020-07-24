# 一键生成 nginx 配置

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 生成 http 配置

命令格式为

```bash
$ ./lnmp-docker nginx-config http 项目路径 url
```

假设项目路径位于 `./app/test`，示例如下

```bash
$ ./lnmp-docker nginx-config http test www.khs1994.com
```

> 注意，执行命令之后请到 `config/nginx/url.conf` 检查配置文件，之后再执行 `./lnmp-docker restart nginx` 重启 `NGINX`。

> 开发、测试环境可能需要修改 `/etc/hosts`。

## 生成 https 配置

生成 https 配置之前请确保拥有 ssl 证书，你可以查看 [下一小节](nginx-with-https.md) 获取证书。

命令格式为

```bash
$ ./lnmp-docker nginx-config https 项目路径 url
```

假设项目路径位于 `./app/test`，示例如下

```bash
$ ./lnmp-docker nginx-config https test www.khs1994.com
```

>注意，执行命令之后请到 `config/nginx/url.conf` 检查配置文件，之后再执行 `./lnmp-docker restart nginx` 重启 `NGINX`。

> 开发、测试环境可能需要修改 `/etc/hosts`。
