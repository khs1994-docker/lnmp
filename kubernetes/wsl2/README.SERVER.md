# K8s Server on WSL2

## 注意事项

* Windows 固定 IP `192.168.199.100`
* `apiServer` 通过 `kube-nginx` 代理到 `https://192.168.199.100:16443`（避免与桌面版 Docker 的 Kubernetes 冲突（6443 端口））
* WSL2 `Ubuntu-18.04` 设为默认 WSL

## 将 `Ubuntu-18.04` 设为版本 2 ,并设置为默认 wsl

```bash
# wsl -h

# 设为默认
$ wsl --set-default Ubuntu-18.04

# 设为版本 2
$ wsl --set-version Ubuntu-18.04 2
```

## 编辑 `.env` `.env.ps1` 文件

* 替换 `192.168.199.100` 为你 Windows 固定 IP

## Master `192.168.199.100`

* `Etcd` Windows
* `kube-nginx` Windows
* `kube-apiserver` WSL2
* `kube-controller-manager` WSL2
* `kube-scheduler` WSL2

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
$ wsl

$ sudo mkdir -p /opt/k8s/{certs,conf,bin,log}
$ sudo cp -a wsl2/certs /opt/k8s/
$ sudo mv /opt/k8s/certs/*.yaml /opt/k8s/conf
$ sudo mv /opt/k8s/certs/*.kubeconfig /opt/k8s/conf

$ sudo cp -a kubernetes-release/release/v1.16.1-linux-amd64/kubernetes/server/bin/kube-{apiserver,controller-manager,scheduler} \
    /opt/k8s/bin
```

## Windows 启动 Etcd

`lwpm` 安装 Etcd

```bash
$ ./wsl2/etcd

$ get-process etcd
```

## Windows 启动 kube-nginx

```bash
$ ./wsl2/kube-nginx

$ get-process nginx
```

## Windows 启动 kube-apiserver

```bash
$ ./wsl2/kube-apiserver start
```

## Windows 启动 kube-controller-manager

```bash
$ ./wsl2/kube-controller-manager start
```

## Windows 启动 kube-scheduler

```bash
$ ./wsl2/kube-scheduler start
```

## 使用 supervisord 管理组件

上面运行于 `WSL2` 中的组件，启动时会占据窗口，我们可以使用 `supervisord` 管理这些组件,避免窗口占用

配置 `supervisor` 请查看 `~/lnmp/docs/supervisord.md`

启动服务端

```bash
$ wsl -u root -- supervisord -c /etc/supervisord.conf -u root
```

生成配置文件

```bash
$ ./wsl2/kube-apiserver
$ ./wsl2/kube-controller-manager
$ ./wsl2/kube-scheduler
```

复制配置文件

```bash
$ wsl -u root -- cp wsl2/supervisor.d/*.ini /etc/supervisor.d/
```

重新载入配置文件

```bash
$ ./wsl2/bin/supervisorctl update
```

启动组件(program 加入 group 之后,不能再用 program 作为参数,必须使用 group:program)

```bash
# 启动单个组件
$ ./wsl2/bin/supervisorctl start kube-server:kube-apiserver
$ ./wsl2/bin/supervisorctl start kube-server:kube-controller-manager
$ ./wsl2/bin/supervisorctl start kube-server:kube-scheduler

# 启动全部组件
$ ./wsl2/bin/supervisorctl start kube-server:
```

## 总结

启动组件有三种方式,下面以 `kube-apiserver` 组件为例,其他组件同理

```bash
# 会占据窗口
$ ./wsl2/kube-apiserver start
```

```bash
$ ./wsl2/bin/supervisorctl start kube-server:kube-apiserver
```

```bash
$ ./wsl2/kube-apiserver start -d
```

### 一键启动

有两种方式

```bash
$ ./wsl2/bin/supervisorctl start kube-server:
```

```bash
$ ./wsl2/bin/kube-server
```
