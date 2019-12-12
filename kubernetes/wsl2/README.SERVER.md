# K8s Server on WSL2 ($ ./wsl2/bin/kube-server)

## 注意事项

* `wsl2.lnmp.khs1994.com` 解析到 WSL2 IP
* `windows.lnmp.khs1994.com` 解析到 Windows IP
* k8s 入口为 **域名** `wsl2.lnmp.khs1994.com:6443` `windows.lnmp.khs1994.com:16443(kube-nginx 代理)`
* WSL2 `Ubuntu-18.04` 设为默认 WSL
* WSL2 **不要** 自定义 DNS 服务器(/etc/resolv.conf)
* 新建 `k8s-data` WSL 发行版用于存储数据
* 接下来会一步一步列出原理,日常使用请查看最后的 **最终脚本 ($ ./wsl2/bin/kube-server)**
* 与 Docker 桌面版启动的 dockerd on WSL2 冲突，请停止并执行 `$ wsl --shutdown` 重新使用本项目

## 将 `Ubuntu-18.04` 设为版本 2 ,并设置为默认 wsl

```bash
# $ wsl -h

# 设为默认
$ wsl --set-default Ubuntu-18.04

# 设为版本 2
$ wsl --set-version Ubuntu-18.04 2
```

## Master

* `Etcd` Windows
* `kube-nginx` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

## 新建 `k8s-data` WSL2 发行版

**必须** 使用 Powershell Core 6 以上版本，Windows 自带的 Powershell 无法使用以下方法。

```powershell
$ cd ~/lnmp

$ . ./windows/sdk/dockerhub/rootfs

$ wsl --import k8s-data `
    $HOME/.khs1994-docker-lnmp/k8s-wsl2/k8s-data `
    $(rootfs alpine) `
    --version 2

# 测试

$ wsl -d k8s-data

$ uname -a
```

由于 WSL 存储机制，硬盘空间不能回收，我们将数据放到 `k8s-data`，若不再需要 `k8s` 直接删除 `k8s-data` 即可。例如 WSL2 放入一个 10G 文件，即使删除之后，这 10G 空间仍然占用，无法回收。

## WSL 配置挂载路径

`/etc/wsl.conf`

* https://raw.githubusercontent.com/khs1994-docker/lnmp/19.03/wsl/config/wsl.conf

```diff
- root = /mnt
+ root = /
```

```bash
$ wsl --shutdown
```

## 挂载 k8s-data `/dev/sdX` 到 `/wsl/k8s-data`

```bash
$ wsl -d k8s-data df -h

Filesystem                Size      Used Available Use% Mounted on
/dev/sdc                251.0G     12.4G    225.8G   5% /

# 在 ubuntu-18.04 中将 /dev/sdc(不固定，必须通过上面的命令获取该值) 挂载到 /wsl/k8s-data

$ wsl -u root -- mkdir -p /wsl/k8s-data
$ wsl -u root -- mount /dev/sdc /wsl/k8s-data
```

## 安装 Docker 和 docker-compose

安装之后启动

```bash
$ sudo service docker start
```

## 获取 kubernetes

```bash
$ cd ~/lnmp/kubernetes

$ wsl

$ ./lnmp-k8s kubernetes-server --url
# $ ./lnmp-k8s kubernetes-server

$ ./lnmp-k8s kubernetes-server --url linux arm64
# $ ./lnmp-k8s kubernetes-server linux arm64
```

## 生成证书文件

```bash
$ cd ~/lnmp/kubernetes

$ docker-compose up cfssl-wsl2
```

## `WSL2` 文件准备

```bash
$ ./wsl2/bin/kube-check

$ wsl

$ set -x
$ source wsl2/.env

$ sudo mkdir -p ${K8S_ROOT:?err}
$ sudo mkdir -p ${K8S_ROOT:?err}/{certs,conf,bin,log}
$ sudo cp -a wsl2/certs ${K8S_ROOT:?err}/
$ sudo mv ${K8S_ROOT:?err}/certs/*.yaml ${K8S_ROOT:?err}/conf
$ sudo mv ${K8S_ROOT:?err}/certs/*.kubeconfig ${K8S_ROOT:?err}/conf

$ sudo cp -a kubernetes-release/release/v1.17.0-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} ${K8S_ROOT:?err}/bin
```

## Windows 启动 Etcd

`lwpm` 安装 Etcd

```powershell
$ ./wsl2/etcd

$ get-process etcd
```

## Windows 启动 kube-nginx

`lwpm` 安装 NGINX

```powershell
$ ./wsl2/kube-nginx

$ get-process nginx
```

## kube-apiserver

```powershell
$ ./wsl2/kube-apiserver start
```

## kube-controller-manager

```powershell
$ ./wsl2/kube-controller-manager start
```

## kube-scheduler

```powershell
$ ./wsl2/kube-scheduler start
```

## 使用 supervisord 管理组件

* http://www.supervisord.org/running.html#running-supervisorctl

上面运行于 `WSL2` 中的组件，启动时会占据窗口，我们可以使用 `supervisord` 管理这些组件，避免窗口占用

### 安装配置 `supervisor`

**请查看 `~/lnmp/docs/supervisord.md`**

### 命令封装

* 使用 `./wsl2/bin/supervisord` 封装 `supervisord`
* 使用 `./wsl2/bin/supervisorctl` 封装 `supervisorctl` 并增加了额外的命令

### 1. 启动 supervisor 服务端

```powershell
# $ .\wsl2\bin\supervisorctl.ps1 pid

# $ wsl -u root -- supervisord -c /etc/supervisord.conf -u root

$ ./wsl2/bin/supervisord
```

### 2. 生成配置文件

```powershell
# $ ./wsl2/kube-apiserver
# $ ./wsl2/kube-controller-manager
# $ ./wsl2/kube-scheduler

$ ./wsl2/bin/supervisorctl g
```

### 3. 重新载入配置文件

```powershell
# 复制配置文件,无需执行! ./wsl2/bin/supervisorctl update 已对该命令进行了封装
# $ wsl -u root -- cp wsl2/supervisor.d/*.ini /etc/supervisor.d/

$ ./wsl2/bin/supervisorctl update
```

### 4. 启动组件

**program 加入 group 之后,不能再用 program 作为参数,必须使用 group:program**

```powershell
# 启动单个组件
$ ./wsl2/bin/supervisorctl start kube-server:kube-apiserver
$ ./wsl2/bin/supervisorctl start kube-server:kube-controller-manager
$ ./wsl2/bin/supervisorctl start kube-server:kube-scheduler

# 或者可以直接启动全部组件
$ ./wsl2/bin/supervisorctl start kube-server:

# $ ./wsl2/bin/supervisorctl status kube-server:
```

### 5. 设置 ~/.kube/config

将 WSL2 K8S 配置写入 `~/.kube/config`

```bash
$ ./wsl2/bin/kubectl-config-set-cluster
```

## 组件启动方式总结

启动组件有三种方式，下面以 `kube-apiserver` 组件为例，其他组件同理

```powershell
# 会占据窗口
$ ./wsl2/kube-apiserver start
```

```powershell
# 对 wsl -u root -- supervisorctl 命令的封装
$ ./wsl2/bin/supervisorctl start kube-server:kube-apiserver
```

```powershell
# 对上一条命令的封装
$ ./wsl2/kube-apiserver start -d
```

## 一键启动

**由于 WSL2 IP 一直在变化，每次必须生成并更新配置**

```powershell
$ ./wsl2/bin/supervisorctl g

$ ./wsl2/bin/supervisorctl update
```

之后启动

```powershell
$ ./wsl2/bin/supervisorctl start kube-server:
```

## 最终脚本(日常使用)

> 请先手动启动 `kube-nginx` `kube-etcd`

```powershell
# $ ./wsl2/kube-nginx
# $ ./wsl2/etcd

$ ./wsl2/bin/kube-server

# $ ./wsl2/bin/kube-server stop
# $ ./wsl2/kube-nginx stop
# $ ./wsl2/etcd stop
```
