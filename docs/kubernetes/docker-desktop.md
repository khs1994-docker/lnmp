# K8s on Docker for Desktop

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

本 Local Server 紧跟最新 Docker EDGE 版本。

## k8s.gcr.io Local Server

> `18.05-EDGE-67` 启动 k8s 所需镜像为 k8s.gcr.io/* 之前为 gcr.io/*

修改 Hosts

```bash
ip k8s.gcr.io gcr.io

# 192.168.199.100 k8s.gcr.io gcr.io
```

> ip 为路由器分配给电脑的 IP，请勿填写 127.0.0.1

### macOS

需要在 Docker 设置中将 `gcr.io` `k8s.gcr.io` 加入到非安全仓库中。

### Windows

Windows 系统每次升级之后，k8s 可能一直处于启动状态中，请首先开启 Local Server，然后在设置中重置 Kubernetes。

### 启动

```bash
$ lnmp-docker gcr.io

# see local server logs (only suport macOS)

$ lnmp-docker gcr.io logs

# when start k8s success,please stop k8s.gcr.io

$ lnmp-docker gcr.io down
```
