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

* https://github.com/containerd/containerd/actions (containerd-*.exe) (下载并移入 PATH)
* https://github.com/microsoft/hcsshim/releases (下载并移入 PATH)
* https://github.com/jterry75/cri (containerd.exe 源码)
* https://github.com/khs1994-docker/k8s-windows/actions (containerd.exe)

```powershell
$ containerd --register-service
```

* 配置文件 `C:\Program Files\containerd\config.toml`

## [Docker](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)

* 配置文件 `$env:programdata\docker\config\daemon.json`

## [Flannel](https://github.com/coreos/flannel/releases)

```powershell
$ New-HNSNetwork `
  -Type overlay `
  -AddressPrefix "192.168.255.0/30" `
  -Gateway "192.168.255.1" `
  -Name "External" `
  -AdapterName "Ethernet" `
  -SubnetPolicies @(@{Type = "VSID"; VSID = 9999; })

# 删除
# $ Get-HnsNetwork | ? Name -eq External | Remove-HnsNetwork
```

## [CNI](https://github.com/containernetworking/plugins/releases)

## kubelet kube-proxy

```bash
$ cd ~/lnmp/kubernetes

$ wsl

$ ./lnmp-k8s kubernetes-server --url windows amd64 node

# ~/lnmp/kubernetes/kubernetes-release/release/v.x.y.z-windows-amd64

# 自行复制二进制文件到 PATH
```

## [crictl](https://github.com/kubernetes-sigs/cri-tools/releases)
