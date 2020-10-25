# Run LNMP on Kubernetes

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![Build Status](https://travis-ci.com/khs1994-docker/lnmp-k8s.svg?branch=master)](https://travis-ci.com/khs1994-docker/lnmp-k8s)

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/16733187/47264269-2467a780-d546-11e8-8cde-f63207ee28d9.jpg">
</p>

* [文档](https://docs.k8s.lnmp.khs1994.com)

* [问题反馈](https://github.com/khs1994-docker/lnmp/issues/122)

## 从 0 开始部署 Kubernetes 集群

### 云服务

* [腾讯云 Kubernetes](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61)
* [阿里云 Kubernetes](https://www.aliyun.com/product/kubernetes?source=5176.11533457&userCode=8lx5zmtu&type=copy)
* [百度云 Kubernetes](https://cloud.baidu.com/product/cce.html)

### 本项目维护方案

* [手动部署 Kubernetes 集群(Fedora CoreOS)](coreos)

* [Linux 单机部署(systemd)](systemd)

* [WSL2(systemd)](wsl2)

* [Docker Desktop](docs/setup/docker-desktop.md)

### 其他方案

* [kubeadm](docs/setup/kubeadm.md)

* [k3s](docs/setup/k3s.md)

* [kind](https://github.com/kubernetes-sigs/kind)

* [microk8s](https://github.com/ubuntu/microk8s)

## 微信订阅号

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/16733187/46847944-84a96b80-ce19-11e8-9f0c-ec84b2ac463e.jpg">
</p>

<p align="center"><strong>关注项目作者微信订阅号，接收项目最新动态</strong></p>

## LNMP Demo

参考 [lnmp](lnmp) 文件夹

## `Helm` or `Kustomize`

固定的 YAML 文件很难扩展，可以使用 `Helm` 或 `Kustomize($ kubectl apply -k XXX)` 灵活的部署应用。具体说明请查看文档。

## [Helm](helm)

## Tips

* [数据持久化](docs/storage/data.md)

* [滚动升级 不停机更新](docs/guide/rollout.md)

* [pod 网络出错](docs/guide/network.md)

## Ubuntu 19.04+ / Debian 10(buster)+ / Fedora 29+

**Ensure iptables tooling does not use the nftables backend**

具体请查看 [这里](./wsl2/README.switch.iptables.md)

## 学习

* 存储 `pv` `pvc` [csi](storage/csi) `flexvolume`
* 网络 `cni` [calico](addons/cni)
* 服务 [ingress](addons/ingress)
* 容器运行时 `cri` `docker` `cri-containerd` `cri-o`
* 监控 [Prometheus](deploy/kube-prometheus)
* 日志 [efk](addons/efk)

## More Information

* [feiskyer/kubernetes-handbook](https://github.com/feiskyer/kubernetes-handbook)
* [Helm Charts](https://github.com/helm/charts)
