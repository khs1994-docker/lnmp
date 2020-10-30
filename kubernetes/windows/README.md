# [Kubernetes on Windows](https://github.com/microsoft/SDN/tree/master/Kubernetes)

* https://github.com/kubernetes-sigs/sig-windows-tools

## 辅助命令

```powershell
$ $PSModulePath=$env:PSModulePath.split(';')[0]
$ mkdir $PSModulePath/hns
$ mkdir $PSModulePath/k8s-helper

$ curl.exe -L https://raw.githubusercontent.com/microsoft/SDN/master/Kubernetes/windows/hns.psm1 -o $PSModulePath/hns/hns.psm1

$ curl.exe -L https://raw.githubusercontent.com/microsoft/SDN/master/Kubernetes/windows/helper.psm1 -o $PSModulePath/k8s-helper/k8s-helper.psm1
```

```powershell
$ import-module hns

$ import-module k8s-helper
```

## [Containerd](https://github.com/microsoft/SDN/tree/master/Kubernetes/containerd)

下载以下文件并移入 PATH

* https://github.com/containerd/containerd/releases/download/v1.4.0/containerd-1.4.0-windows-amd64.tar.gz **containerd.exe** **containerd-shim-runhcs-v1.exe** **ctr.exe**
* https://github.com/microsoft/hcsshim/releases **runhcs.exe**

```powershell
$ containerd --register-service
```

* 默认配置文件 `C:\Program Files\containerd\config.toml`

## [Docker](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)

* 默认配置文件 `$env:programdata\docker\config\daemon.json`

* Docker + Containerd https://github.com/moby/moby/pull/38541

## CNI

* https://github.com/containernetworking/plugins/releases
* https://github.com/microsoft/windows-container-networking

## 获取 kubelet kube-proxy

```bash
$ cd ~/lnmp/kubernetes

$ wsl

$ ./lnmp-k8s kubernetes-server windows amd64 node

# ~/lnmp/kubernetes/kubernetes-release/release/v.x.y.z-windows-amd64

# 自行复制二进制文件 kubelet kube-proxy 到 PATH
```

## [crictl](https://github.com/kubernetes-sigs/cri-tools/releases)

## Windows 镜像

* https://hub.docker.com/publishers/microsoftowner
