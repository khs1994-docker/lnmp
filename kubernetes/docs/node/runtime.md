# Container Runtime

* https://kubernetes.io/docs/setup/production-environment/container-runtimes/

## Docker

## Containerd

* http://dockone.io/search/q-Y29udGFpbmVyZA==#all
* http://dockone.io/article/5806
* https://kubernetes.io/blog/2017/11/containerd-container-runtime-options-kubernetes/
* https://kubernetes.io/blog/2018/05/24/kubernetes-containerd-integration-goes-ga/

## CRI-O

* https://www.jianshu.com/p/5c7ffe9328e9
* https://github.com/cri-o/cri-o#installing-cri-o
* https://github.com/cri-o/cri-o/blob/master/tutorial.md
* https://github.com/cri-o/cri-o/blob/master/tutorials/kubernetes.md

### Fedora kubernetes DNS 解析不了

与 `virbr0` 网卡有关，关闭相关进程。

```bash
$ sudo nmcli device delete virbr0

$ sudo systemctl disable libvirtd.service
```

* https://www.cnblogs.com/cloudos/p/8288041.html
