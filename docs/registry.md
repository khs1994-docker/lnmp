# Docker Registry

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

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
      httpd:alpine \
      -Bbn $username $password > config/nginx/auth/docker_registry.htpasswd

# 部分 nginx 可能不能解密，你可以替换为下面的命令
# -mbn $username $password > config/nginx/auth/docker_registry.htpasswd

$ cp config/nginx/demo-registry.config config/nginx/registry.conf

# 4. 编辑 config/nginx/registry.conf 文件
# 替换 REGISTRY_DOMAIN 为 docker.t.khs1994.com

# 5. 编辑 docker registry 配置文件 config/registry/config.yml
```

## 自签名证书

* https://www.aidmin.cn/server/docker-registry-with-self-signed-ssl-certificate.html
* https://docs.docker.com/registry/insecure/#use-self-signed-certificates
* https://docs.docker.com/docker-for-windows/faqs/#how-do-i-add-custom-ca-certificates
* https://docs.docker.com/docker-for-windows/#adding-tls-certificates
* https://docs.docker.com/engine/security/certificates/

如果你的证书为自签名证书

Linux 上将 CA 证书放入 `/etc/docker/certs.d/myregistrydomain.com:5000/ca.crt`(Docker 守护端所在主机)，在 Docker 桌面版(Windows、macOS)中放到 `~/.docker/certs.d/myregistrydomain.com:5000/ca.crt`。

> 若 registry 解析到 `127.0.0.0/8`，可能不需要配置。

```bash
/etc/docker/certs.d/           <-- Certificate directory
└── localhost:5000             <-- Hostname:port
    ├── client.cert            <-- Client certificate
    ├── client.key             <-- Client key
    └── ca.crt                 <-- Certificate authority that signed
                                 the registry certificate

└── https.registry.domain.com  <-- Hostname without port
    ├── client.cert
    ├── client.key
    └── ca.crt
```

若启用了验证功能(密码登录)，可能仍然会 [出现错误](https://docs.docker.com/registry/insecure/#troubleshoot-insecure-registry)。这时 **必须** 将 CA 写入系统文件夹(Docker 守护端所在主机)。

**Linux**

```bash
# centos
$ cp config/nginx/ssl/root-ca.crt /etc/pki/ca-trust/source/anchors/myregistrydomain.com.crt
$ update-ca-trust

# ubuntu
$ cp config/nginx/ssl/root-ca.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt
$ update-ca-certificates

# 重启 docker

$ sudo systemctl restart docker
```

**Windows**

* https://docs.docker.com/registry/insecure/#windows

* 右键点击 CA 证书，选择 `安装证书`
* Store location: local machine （`存储位置` -> `本地计算机` -> `下一步`）
* Check place all certificates in the following store（选择 `将所有的证书都放入下列存储`）
* Click Browser, and select Trusted Root Certificate Authorities（点击 `浏览`，选择 `受信任的根证书颁发机构`，点击 `确定`，下一步）
* Click Finish (点击 `完成`)
* 重启 Docker

* https://docs.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc754841(v=ws.11)?redirectedfrom=MSDN

**macOS**

```bash
$ security add-trusted-cert -d -r trustRoot -k ~/Library/Keychains/login.keychain ca.crt
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
