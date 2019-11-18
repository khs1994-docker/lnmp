# Run LNMP on Kubernetes

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![Build Status](https://travis-ci.com/khs1994-docker/lnmp-k8s.svg?branch=master)](https://travis-ci.com/khs1994-docker/lnmp-k8s)

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [文档](https://docs.k8s.lnmp.khs1994.com)

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/122)

## 从 0 开始部署 Kubernetes 集群

### 云服务

* [腾讯云 Kubernetes](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
* [阿里云 Kubernetes](https://www.aliyun.com/product/kubernetes?source=5176.11533457&userCode=8lx5zmtu&type=copy)
* [百度云 Kubernetes](https://cloud.baidu.com/product/cce.html)

### 本项目维护方案

* [手动部署 Kubernetes 集群(Fedora CoreOS)](coreos)

* [Linux 单机部署(systemd)](systemd)

* [Docker Desktop](docs/setup/docker-desktop.md)

* [Windows(etcd,kube-nginx) + WSL2(master) + 树莓派(node)](rpi)

* [Windows(etcd,kube-nginx) + WSL2(master + node)](wsl2)

### 其他方案

* [MiniKube](docs/setup/minikube.md)

* [kubeadm](docs/setup/kubeadm.md)

* [k3s](docs/setup/k3s.md)

* [kind](https://github.com/kubernetes-sigs/kind)

* [microk8s](https://github.com/ubuntu/microk8s)

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## 注意事项

* `lnmp-k8s` 脚本在 Windows 或 macOS 上执行的 k8s 目标集群为 **Docker 桌面版启动的 k8s 集群**，未考虑在 Windows 或 macOS 操作 **其他（远程） k8s 集群** 的情况。（相信有能力操作远程集群的人群不再需要本项目的一键脚本）

* 本项目是给大家提供一个 lnmp k8s yaml 文件的模板，具体内容还请根据实际情况自行更改

* 本项目专为 Laravel 设计，能够完美的在 Kubernetes 之上运行 Laravel

* Docker 桌面版 K8s 运行 Laravel 响应慢

* Linux 版本优先考虑多节点方案,所以 `pv` 采用 `NFS` 卷,而不是 `hostPath`(执行 `$ lnmp-k8s nfs` 可以启动 NFS Server )

* Docker 桌面版不支持启动 NFS Server 容器，若需 NFS 卷，请自行在 Linux 上部署 NFS Server 容器或在 `WSL2` 上启动 NFS server 容器(执行 `$ lnmp-k8s nfs` 可以启动 NFS Server 容器, [需设置变量](volumes/README.md))

* 由于虚拟机模拟集群环境硬盘空间占用太大，又不能及时回收，为了方便大家学习，本项目支持在 Linux 单机上部署 Kubernetes (通过 systemd 管理)`$ lnmp-k8s local-install`

## Demo

> 部署好 Kubernetes 集群之后，按照以下步骤启动 LNMP Demo

```bash
# 部署 LNMP
# 事先部署好 NFS 服务端(v4), 并在 .env 文件中配置 `LNMP_NFS_SERVER_HOST`,具体参考 volumes 文件夹中的内容
# 或者你可以加上 [ --no-nfs ] 避免使用 NFS 数据卷

$ ./lnmp-k8s create development --no-nfs

# PHP 项目开发
$ cd ~/app # 或者 NFS 路径

$ mkdir my-project

# 在新建的文件夹内进行 PHP 项目开发

# 配置 NGINX
$ cd ~/lnmp/kubernetes/deployment/configMap/nginx-conf-d

# 新建文件(文件后缀名必须为 conf)或将新增配置追加到已有文件中

$ vi filename.conf

# 创建新版本的 configmap
$ kubectl -n lnmp create configmap lnmp-nginx-conf.d-0.0.2 --from-file deployment/configMap/nginx-conf-d

$ kubectl -n lnmp label configmap lnmp-nginx-conf.d-0.0.2 app=lnmp version=0.0.2

# 编辑 nginx
$ kubectl -n lnmp edit deployment nginx
```

```diff
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      volumes:
      - configMap:
-         name: lnmp-nginx-conf.d-0.0.1
+         name: lnmp-nginx-conf.d-0.0.2
        name: lnmp-nginx-conf-d
```

保存文件,即可更新 nginx。

### 停止 LNMP ,保留数据

```bash
$ ./lnmp-k8s delete development
```

### 销毁 LNMP ,不保留数据（谨慎操作）

```bash
$ ./lnmp-k8s cleanup development
```

## `Helm` or `Kustomize`

固定的 YAML 文件很难扩展，可以使用 `Helm` 或 `Kustomize($ kubectl apply -k XXX)` 灵活的部署应用。具体说明请查看文档。

## [Helm](helm)

* 完美支持 `开发` `测试` `预上线` `生产` 四种环境

## Tips

* [数据持久化](docs/storage/data.md)

* [滚动升级 不停机更新](docs/guide/rollout.md)

* [pod 网络出错](docs/guide/network.md)

## 学习

* 存储 `pv` `pvc` `flexvolume` `csi`
* 网络 `cni` `flannel` `calico`
* 容器运行时 `cri` `docker` `cri-containerd` `cri-o`
* 监控
* 服务 `ingress`

## More Information

* [feiskyer/kubernetes-handbook](https://github.com/feiskyer/kubernetes-handbook)
* [Helm Charts](https://github.com/helm/charts)
