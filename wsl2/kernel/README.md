# WSL2-Linux-Kernel

* https://github.com/khs1994/WSL2-Linux-Kernel

> 所构建的内核请到 https://github.com/khs1994/WSL2-Linux-Kernel/releases 或 Actions 详情 Artifacts 下载

如何使用请查看

* https://github.com/khs1994-docker/lnmp/blob/master/kubernetes/wsl2/README.KERNEL.md

## 已知问题

* 无

## .deb

* `/lib/modules/$(uname -r)`
* `/usr/include`
* `/usr/src/linux-headers-$(uname -r)`

## .img

在 Windows `~/.wslconfig` 中配置内核地址

## modules.builtin

* `/lib/modules/$(uname -r)/modules.builtin`

## 新增模块

* nfs
* iscsi
* ipip (calico CNI)
* eBPF (calico CNI)

## 内核编译参数

```bash
$ zcat /proc/config.gz
```
