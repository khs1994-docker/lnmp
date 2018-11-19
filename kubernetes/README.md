# Run LNMP on Kubernetes

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/122)

* **Windows** 用户务必安装 `WSL`

* 本项目的目标是超大规模 Kubernetes LNMP 集群(首要考虑的是跨节点问题)

## Kubernetes 基础设施(从 0 开始搭建 Kubernetes 集群)

* [自己手动部署 Kubernetes 集群(CoreOS)](coreos)

* [Linux 单机部署](systemd)

* [Docker Desktop](docs/docker-desktop.md)

* [MiniKube](docs/minikube.md)

* [腾讯云 实验室免费体验 8 小时（可循环） ](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>


## 注意事项

* 本项目今后可能通过 Helm 分发（建议用户了解 K8s 基本概念之后，尽快了解 Helm）

* `lnmp-k8s` 脚本在 Windows 或 macOS 上执行的 k8s 目标集群为 **Docker 桌面版启动的 k8s 集群**，未考虑在 Windows 或 macOS 操作 **远程 k8s 集群** 的情况。（相信有能力操作远程集群的人群不再需要本项目的一键脚本）

* 本项目是给大家提供一个 lnmp k8s yaml 文件的模板，具体内容还请根据实际情况自行更改

* 本项目专为 Laravel 设计，能够完美的在 Kubernetes 之上运行 Laravel

* Docker 桌面版 K8s 运行 Laravel 响应慢

* Linux 版本优先考虑多节点方案,所以 `pv` 采用 `NFS` 卷,而不是 `hostPath`(执行 `$ lnmp-docker nfs` 可以快速的启动 NFS 服务端 )

* Docker 桌面版不支持启动 NFS 服务端容器，若需 NFS 卷，请自行在 Linux 上部署 NFS 容器

* 由于虚拟机模拟集群环境硬盘空间占用太大，又不能及时回收，为了方便大家学习，你也可以在 Linux 单机上部署 Kubernetes (通过 systemd 管理)`$ lnmp-k8s single-install`

## Demo

```bash
$ cd kubernetes

# 部署 LNMP
$ ./lnmp-k8s create

# PHP 项目开发
$ cd ~/app

$ mkdir my-project

# 在新建的文件夹内进行 PHP 项目开发

# 配置 NGINX
$ cd ~/lnmp/kubernetes/deployment/configMap/nginx-conf-d

# 新建文件(文件后缀名必须为 conf)或将新增配置追加到已有文件中

$ vi filename.conf

# 创建新版本的 configmap
$ kubectl create configmap lnmp-nginx-conf-d-0.0.2 --from-file deployment/configMap/nginx-conf-d

$ kubectl label configmap lnmp-nginx-conf-d-0.0.2 app=lnmp version=0.0.2

$ kubectl edit deployment nginx

# 更新配置信息，保存文件即可。

# 停止 LNMP 保留数据

$ ./lnmp-k8s delete

# 销毁 LNMP 销毁所有数据

$ ./lnmp-k8s cleanup
```

## [Helm (终极方案)](helm)

* 完美支持 `开发` `测试` `预上线` `生产` 四种环境

## Tips

* [数据持久化](docs/volume/data.md)

* [Windows 10](docs/windows.md)

* [滚动升级 不停机更新](docs/rollout.md)

* [pod 网络出错](docs/network.md)

## 资源占用

* `Core DNS` + `Dashboard` + `Heapster` + `Metrics Server` + `EFK` + `LNMP`

```bash
NAME      CPU(cores)   CPU%      MEMORY(bytes)   MEMORY%
coreos1   217m         21%       1710Mi          58%
coreos2   249m         24%       2258Mi          77%
coreos3   267m         26%       2353Mi          81%
```

## More Information

* [feiskyer/kubernetes-handbook](https://github.com/feiskyer/kubernetes-handbook)
* [Helm Charts](https://github.com/helm/charts)
