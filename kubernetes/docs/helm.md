# Helm With TLS

## 安装客户端 helm

* https://github.com/helm/helm

在 GitHub Release 处下载二进制文件，放入 PATH 即可

* 需要安装 `socat`，yum apt 直装即可

## 客户端

证书直接用之前生成的，具体原理和 Dockerd TLS 一样

之前没有生成证书，使用如下命令生成证书

编辑 `./coreos/.env` 文件中的变量

```bash
$ docker-compose up cfssl
```

下载二进制文件，放入 PATH

把客户端证书放入指定文件夹，减少命令参数，这点和启用了 Dockerd TLS 认证的原理一样

```bash
$ mkdir -p ~/.helm

$ cp coreos/cert/ca.pem $(helm home)/ca.pem
$ cp coreos/cert/cert.pem $(helm home)/cert.pem
$ cp coreos/cert/key.pem $(helm home)/key.pem
$ cp coreos/cert/server-cert.pem $(helm home)/server-cert.pem
$ cp coreos/cert/server-key.pem $(helm home)/server-key.pem
```

### Winodws、macOS Docker 桌面版 k8s 集群

编辑 `systemd/.env` 中的变量，之后生成证书

```bash
$ ./lnmp-k8s

$ docker-compose up cfssl-single
```

之后将 `server-cert.pem` `server-key.pem` `ca.pem` `cert.pem` `key.pem` 复制到 `~/.helm`

## 服务端部署 Tiller

* 由于网络问题，替换为国内源

```bash
$ cd ~/.helm

$ helm init --tiller-tls --tiller-tls-cert ./server-cert.pem \
      --tiller-tls-key ./server-key.pem \
      --tiller-tls-verify --tls-ca-cert ./ca.pem \
      --service-account=tiller \
      --upgrade -i \
      gcr.mirrors.ustc.edu.cn/kubernetes-helm.tiller:v2.10.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```

客户端使用时加上 `--tls`

### Winodws、macOS Docker 桌面版 k8s 集群

```bash
$ cd ~/.helm

# Windows
$ helm init --tiller-tls --tiller-tls-cert ./server-cert.pem `
      --tiller-tls-key ./server-key.pem `
      --tiller-tls-verify --tls-ca-cert ./ca.pem `
      --service-account=tiller `
      --upgrade -i `
      gcr.mirrors.ustc.edu.cn/kubernetes-helm.tiller:v2.10.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

# macOS
$ helm init --tiller-tls --tiller-tls-cert ./server-cert.pem \
      --tiller-tls-key ./server-key.pem \
      --tiller-tls-verify --tls-ca-cert ./ca.pem \
      --service-account=tiller \
      --upgrade -i \
      gcr.mirrors.ustc.edu.cn/kubernetes-helm.tiller:v2.10.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

```

## RBAC

```bash
$ cd ~/lnmp/kubernetes

$ kubectl apply -f addons/helm/rbac-config.yaml
```

## Helm 仓库 Charts

* https://github.com/helm/charts
