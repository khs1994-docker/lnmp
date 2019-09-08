# Docker Registry

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 配置

参考 [LREW](lrew.md) 启用 `registry`。

笔者以 `docker.t.khs1994.com` 为 `Docker Registry` 的地址，请读者根据实际替换为自己的地址。

```bash
# 1. 生成证书
$ ./lnmp-docker ssl-self docker.t.khs1994.com
# 或者放入你自己的证书 config/nginx/ssl
# docker.t.khs1994.com.key
# docker.t.khs1994.com.crt

# 2. 生成密钥
$ username=root ; password=root
$ docker run --init --rm \
      --entrypoint htpasswd \
      registry \
      -Bbn $username $password > config/nginx/auth/docker_registry.htpasswd

# 部分 nginx 可能不能解密，你可以替换为下面的命令
# -mbn $username $password > config/nginx/auth/docker_registry.htpasswd

$ cp config/nginx/demo-registry.config config/nginx/registry.conf

# 4. 编辑 config/nginx/registry.conf 文件
# 替换 REGISTRY_DOMAIN 为 docker.t.khs1994.com

# 5. 编辑 docker registry 配置文件 config/registry/config.yml
```

## CA

* https://www.aidmin.cn/server/docker-registry-with-self-signed-ssl-certificate.html

如果你的证书为自签名证书，必须将 CA 写入系统文件夹。

```bash
$ cat config/nginx/ssl/root-ca.crt | sudo tee -a /etc/pki/tls/certs/ca-bundle.crt

# 重启 docker

$ sudo systemctl restart docker
```

## 启动

```bash
$ ./lnmp-docker up
```

## 测试

```bash
$ docker login docker.t.khs1994.com

$ docker pull alpine

$ docker tag alpine docker.t.khs1994.com/alpine

$ docker push docker.t.khs1994.com/alpine
```
