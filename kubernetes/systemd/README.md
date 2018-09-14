# 使用 systemd 部署单节点 Kubernetes 集群

## 准备

* 了解 `systemd`

## 关闭防火墙

```bash
$ sudo systemctl stop firewalld && systemctl disable firewalld
```

刚开始搭建的时候，出现 pod 网络不通的情况，可以尝试关闭防火墙

## 替换

* `192.168.199.100` 替换为电脑 IP 或公有云主机公网 IP

* `node1` 替换为 hostname

## 修改 hostname

hostname 与 etcd 启动时指定的 `--name` 必须一致

```bash
$ hostnamectl set-hostname node1
```

## 部署

```bash
# 生成证书
$ dockr-composer up cfssl-single

# 部署
$ ./lnmp-k8s single-install

# 启动
$ ./lnmp-k8s single-start
# 按照提示，手动执行 systemctl 命令，依次启动 kubernetes 各组件
# 为了方便大家熟悉各组件，启动命令只进行提示！
```

### 脚本原理

将 `*.service` 放入 `/etc/systemd/system/*`

将 `docker.conf` 放入 `/etc/systemd/system/docker.service.d/*` 中
