# Container Runtime (CRI)

* https://kubernetes.io/docs/setup/production-environment/container-runtimes/

## Docker

## Containerd

* http://dockone.io/search/q-Y29udGFpbmVyZA==#all
* http://dockone.io/article/5806
* https://kubernetes.io/blog/2017/11/containerd-container-runtime-options-kubernetes/
* https://kubernetes.io/blog/2018/05/24/kubernetes-containerd-integration-goes-ga/
* https://github.com/containerd/cri/blob/master/docs/config.md

## CRI-O

* https://www.jianshu.com/p/5c7ffe9328e9
* https://github.com/cri-o/cri-o/blob/master/install.md
* https://github.com/cri-o/cri-o/blob/master/tutorials/kubernetes.md
* https://gitee.com/docker_practice/cri-o/blob/master/tutorials/install-distro.md

crio 会加载 `/etc/containers/` 下的配置。

* `/var/run/containers/storage`

### Fedora kubernetes DNS 解析不了

与 `virbr0` 网卡有关，关闭相关进程。

```bash
$ sudo nmcli device delete virbr0

$ sudo systemctl disable libvirtd.service
```

* https://www.cnblogs.com/cloudos/p/8288041.html

### 镜像加速器

最好在运行时级别设置好镜像加速器，例如 `gcr.io` => `gcr.mirror`,具体请查看运行时配置文件。

### Cgroup Driver

* `cgroupfs` or `systemd`

* https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers
