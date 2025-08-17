# K8s Server on WSL2

## 注意事项

* `WSL2` 配置 `networkingMode=nat`
* k8s 入口为 **域名** `wsl2.k8s.khs1994.com:6443`
* WSL2 **不要** 自定义 DNS 服务器(不要自行编辑 /etc/resolv.conf)
* 新建 `wsl-k8s` WSL2 发行版用于 k8s 运行
* 本项目与 **Docker 桌面版** 冲突，请先停止 **Docker 桌面版** 并执行 `$ wsl --shutdown` 后使用本项目

## Master

* `Etcd` WSL2
* `kube-wsl2windows` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

## 配置 WSL2

```bash
# Windows 中 ~/.wslconfig
[wsl2]
networkingMode=nat
swap=0
[experimental]
sparseVhd=true
```

## 初始化

```powershell
$ ./lnmp-k8s
```

## 新建 `wsl-k8s` WSL2 发行版并进行配置

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ . ../windows/sdk/dockerhub/rootfs

$ $env:WSL_K8S_WSL2_InstallLocation="$env:LOCALAPPDATA\wsl-k8s"

$ wsl --import wsl-k8s `
    $env:WSL_K8S_WSL2_InstallLocation `
    $(rootfs library-mirror/debian sid-slim -registry ccr.ccs.tencentyun.com) `
    --version 2

$ wsl -d wsl-k8s -- uname -a
```

### 修改 APT 源并安装必要软件

```powershell
$ wsl -d wsl-k8s -- sh -c 'test -f /etc/apt/sources.list && sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list || true'
$ wsl -d wsl-k8s -- sh -c 'test -f /etc/apt/sources.list.d/debian.sources && sed -i "s/deb.debian.org/mirrors.tencent.com/g" /etc/apt/sources.list.d/debian.sources || true'
# $ wsl -d wsl-k8s -- sed -i "s/archive.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list
# $ wsl -d wsl-k8s -- sed -i "s/security.ubuntu.com/mirrors.tencent.com/g" /etc/apt/sources.list

$ wsl -d wsl-k8s -- apt update

# procps => ps 命令
$ wsl -d wsl-k8s -- apt install -y procps bash-completion iproute2 jq curl vim fdisk net-tools
# systemd
$ wsl -d wsl-k8s -- apt install -y systemd dbus dbus-user-session udev
```

### 复制配置文件

```powershell
$ wsl -d wsl-k8s -- sh -xc 'cp wsl2/conf/etc/wsl.conf /etc/wsl.conf && cat /etc/wsl.conf'
# 停止 WSL 使配置生效
$ wsl --shutdown
```

## 获取 kubernetes

```powershell
$ wsl -d wsl-k8s -- KUBERNETES_VERSION=1.33.0 ./lnmp-k8s kubernetes-server --url
# 如果上面的命令出现错误，可以执行这个命令
# $ rm -r -force kubernetes-release\release\kubernetes-server-linux-amd64-1.33.0.tar.gz
# $ wsl -d wsl-k8s -- KUBERNETES_VERSION=1.33.0 ./lnmp-k8s kubernetes-server

# 其他架构
# $ wsl -d wsl-k8s -- KUBERNETES_VERSION=1.33.0 ./lnmp-k8s kubernetes-server --url linux arm64
# $ wsl -d wsl-k8s -- KUBERNETES_VERSION=1.33.0 ./lnmp-k8s kubernetes-server linux arm64
```

## 生成证书文件

```powershell
$env:WSLENV="CFSSL_ROOT/u:CFSSL_ROOTFS/u"
$env:CFSSL_ROOT="/wsl/wsl-k8s-data/cfssl"
$env:CFSSL_ROOTFS="/wsl/wsl-k8s-data/cfssl/rootfs"

$ wsl -d wsl-k8s -- sh -xc 'mkdir -p ${CFSSL_ROOT:?err}'
$ . ../windows/sdk/dockerhub/rootfs
$ foreach($item in 0,1,2,3,4){ `
      $tar_gz_file=rootfs khs1994-docker/khs1994/k8s-cfssl `
          -ref latest -registry docker.cnb.cool -layersIndex $item ; `
       cp $tar_gz_file \\wsl$\wsl-k8s\"${env:CFSSL_ROOTFS}${item}".tar.gz
  }

$ wsl -d wsl-k8s -- sh -xc 'mkdir -p ${CFSSL_ROOTFS:?err}'
$ wsl -d wsl-k8s -- sh -xc 'for tar in ${CFSSL_ROOT:?err}/*.tar.gz ; do tar -C ${CFSSL_ROOTFS:?err} -zxvf \$tar;done'

$ wsl -d wsl-k8s -- sh -xc 'cp wsl2/cfssl/config.json ${CFSSL_ROOT:?err}/'
$ wsl -d wsl-k8s -- bash -xc 'cp wsl2/{.env,.env.example} cfssl/{docker-entrypoint.sh,kube-scheduler.config.yaml} ${CFSSL_ROOTFS:?err}/'

$ wsl -d wsl-k8s -- ./lnmp-k8s _runc_install
$ wsl -d wsl-k8s -- sh -xc 'cd ${CFSSL_ROOT:?err} && runc run cfssl'
```

## `WSL2` 文件准备

```powershell
$env:WSLENV="K8S_ROOT/u"
$env:K8S_ROOT="/wsl/wsl-k8s-data/k8s"
$ wsl -d wsl-k8s -- bash -xc 'mkdir -p ${K8S_ROOT:?err}/{etc/kubernetes/pki,bin}'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml       ${K8S_ROOT:?err}/etc/kubernetes'
$ wsl -d wsl-k8s -- sh -xc 'cp ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes'

$ $env:WSLENV="K8S_ROOT/u:KUBERNETES_VERSION"
# 请将 1.33.0 替换为实际的 k8s 版本号
$ $env:KUBERNETES_VERSION='1.33.0'
$ wsl -d wsl-k8s -- bash -xc 'cp -a kubernetes-release/release/v${KUBERNETES_VERSION}-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin'
```

## 工作节点配置

请查看 [00-README.NODE.md](00-README.NODE.md)
