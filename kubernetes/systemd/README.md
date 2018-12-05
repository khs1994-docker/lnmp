# 使用 systemd 部署单节点 Kubernetes 集群

## 准备

* 了解 `systemd`

## 安装依赖软件

* https://k8s-install.opsnull.com/07-0.%E9%83%A8%E7%BD%B2worker%E8%8A%82%E7%82%B9.html

```bash
$ sudo yum install conntrack ipvsadm ipset jq iptables curl sysstat libseccomp && sudo /usr/sbin/modprobe ip_vs
```

```bash
$ sudo dnf install conntrack ipvsadm ipset jq iptables curl sysstat libseccomp && sudo /usr/sbin/modprobe ip_vs
```

```bash
$ sudo apt install -y conntrack ipvsadm ipset jq iptables curl sysstat libseccomp && sudo /usr/sbin/modprobe ip_vs
```

## 关闭防火墙

```bash
$ sudo systemctl stop firewalld && systemctl disable firewalld
```

刚开始搭建的时候，出现 pod 网络不通的情况，可以尝试关闭防火墙

## 编辑 `.env` 文件

`~/lnmp/kubernetes/systemd/.env`

* `192.168.199.100` 替换为电脑 IP 或公有云主机公网 IP

* `node1` 替换为 hostname

## 修改 hostname

hostname 与 etcd 启动时指定的 `--name` 必须一致

```bash
$ hostnamectl set-hostname node1
```

## 增加 hosts

`/etc/hosts`

```bash
# 节点IP hostname

192.168.199.100 node1
```

## 部署

```bash
# 生成证书
$ dockr-composer up cfssl-single

# 下载 Kubernetes 二进制文件
$ ./lnmp-k8s kubernetes-server

# 部署
$ ./lnmp-k8s single-install

# 启动
$ ./lnmp-k8s single-start
# 按照提示，手动执行 systemctl 命令，依次启动 kubernetes 各组件
# 为了方便大家熟悉各组件，启动命令只进行提示！
```

### 手动复制 `kubectl` 配置文件

复制 `kubectl` 配置文件，为防止覆盖原有文件，脚本不支持自动复制，必须手动复制

```bash
$ cd ~/lnmp/kubernetes

$ cp systemd/certs/kubectl.kubeconfig ~/.kube/config
```

### 脚本原理

将 `*.service` 放入 `/etc/systemd/system/*`

将 `docker.conf` 放入 `/etc/systemd/system/docker.service.d/*` 中
