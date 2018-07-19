# K8s on Docker for Desktop

本 Local Server 紧跟最新 Docker EDGE 版本。

## k8s.gcr.io Local Server

> `18.05-EDGE-67` 启动 k8s 所需镜像为 k8s.gcr.io/* 之前为 gcr.io/*

修改 Hosts

```bash
ip k8s.gcr.io gcr.io
```

> ip 为路由器分配给电脑的 IP，请勿填写 127.0.0.1

Windows 系统每次升级之后，k8s 可能一直处于启动状态中，请首先开启 Local Server，然后在设置中重置 Kubernetes。

```bash
$ lnmp-docker gcr.io

# see local server logs (only suport macOS)

$ lnmp-docker gcr.io logs

# when start k8s success,please stop k8s.gcr.io

$ lnmp-docker gcr.io down
```
