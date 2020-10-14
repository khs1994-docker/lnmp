# WSL2-Linux-Kernel

* https://github.com/khs1994/WSL2-Linux-Kernel

> 所构建的内核请到 https://github.com/khs1994/WSL2-Linux-Kernel/releases 或 Actions 详情 Artifacts 下载

如何使用请查看

* https://github.com/khs1994-docker/lnmp/blob/master/kubernetes/wsl2/README.KERNEL.md

## 已知问题

* 使用最新 Linux 源码编译的内核可能会造成 Docker 桌面版崩溃，推荐使用 https://github.com/microsoft/WSL2-Linux-Kernel/branches 支持的内核版本（例如 **5.4.x** **4.19.x**）

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

## 内存回收

* https://devblogs.microsoft.com/commandline/memory-reclaim-in-the-windows-subsystem-for-linux-2/

使用官方版本的 [Linux](https://github.com/torvalds/linux) 构建的内核，使用 `memory-reclaim.diff` patch 以启用内存回收功能。

## 内核编译参数

```bash
$ zcat /proc/config.gz
```
