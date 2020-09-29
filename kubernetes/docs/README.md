---
home: true
actionText: （AD）腾讯云容器服务
actionLink: https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61
features:
- title: 开始 Kubernetes 之旅
  details: ''
- title: 部署 Kubernetes
  details: 在 Linux 单机(或集群中)使用 systemd 部署 Kubernetes
- title: 支持 Laravel
  details: ''
footer: Copyright @2019 khs1994.com
---

# K8s LNMP Docs

> 本文档 **不会** 一步一步的教你如何部署 Kubernetes，只是记录一些本人搭建时遇到的问题及一些关键提示或步骤，如果你在遇到问题时，选择对应的主题查看，也许会发现解决方法。

## 准备

* Linux 知识
* systemd 知识
* Docker 知识

## 部署 Kubernetes

请查看 [GitHub](https://github.com/khs1994-docker/lnmp-k8s) README.md 文件。

详细的搭建教程请查看这个项目：https://github.com/opsnull/follow-me-install-kubernetes-cluster

## YAML 文件

请在 `deployment` 文件夹查看。

## Service

Service 通过 `Label Selector` 来匹配一系列的 Pod，Label Selector 允许在 Label 上做一系列的逻辑操作。

![](https://kubernetes.io/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg)

## 服务暴露方式

* https://blog.csdn.net/newcrane/article/details/79092577

* https://blog.csdn.net/limx59/article/details/71717275

* https://www.cnblogs.com/devilwind/p/8891636.html

```bash

internet
    |
------------
[ Services ]

```

### ClusterIP

ClusterIP 服务是 Kubernetes 的默认服务。它给你一个集群内的服务，集群内的其它应用都可以访问该服务。集群外部无法访问它。

如果 从Internet 没法访问 ClusterIP 服务，那么我们为什么要讨论它呢？那是因为我们可以通过 Kubernetes 的 proxy 模式来访问该服务！

### Nodeport

把 service 的 port 映射到每个节点内部指定 port 上，所有节点内部映射的 port 都一样。

NodePort Service 是通过在节点上暴漏端口，然后通过将端口映射到具体某个服务上来实现服务暴漏，比较直观方便，但是对于集群来说，随着 Service 的不断增加，需要的端口越来越多，很容易出现端口冲突，而且不容易管理。当然对于小规模的集群服务，还是比较不错的。

NodePort 服务主要有两点区别于普通的 ClusterIP 服务。第一，它的类型是 NodePort 。有一个额外的端口，称为 nodePort，它指定节点上开放的端口值 。如果你不指定这个端口，系统将选择一个随机端口。大多数时候我们应该让 Kubernetes 来选择端口，因为如评论中 thockin 所说，用户自己来选择可用端口代价太大。

### Loadbalancer （公有云）

LoadBlancer Service 是 Kubernetes 结合云平台的组件，如国外 GCE、AWS、国内阿里云等等，使用它向使用的底层云平台申请创建负载均衡器来实现，有局限性，对于使用云平台的集群比较方便。

> Docker 桌面版也可以使用

### Ingress

```bash

internet
    |
[ Ingress ]
--|-----|--
[ Services ]

```

### [Traefik](https://github.com/traefik/traefik)

![](https://raw.githubusercontent.com/containous/traefik/master/docs/content/assets/img/traefik-architecture.png)

## 官方文档导引

* [组件](https://kubernetes.io/docs/concepts/overview/components/)

# More Information

* https://github.com/kubernetes/examples
* https://my.oschina.net/u/3797264
* https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
* https://kubernetes.io/docs/reference/command-line-tools-reference/

# Build Docs(Vue Press)

```bash
$ npm i -g vuepress

$ vuepress dev

$ vuepress build
```
