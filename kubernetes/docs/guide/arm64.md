# [arm64](https://github.com/khs1994/pi64)

## 内核启动参数设置

默认参数下的警告信息:

```bash
WARNING: No memory limit support
WARNING: No swap limit support
WARNING: No kernel memory limit support
WARNING: No kernel memory TCP limit support
WARNING: No oom kill disable support
```

```bash
$ sudo vi /boot/cmdline.txt
```

增加以下参数:

```bash
cgroup_enable=memory cgroup_enable=cpuset
```

### 原始数据

```bash
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait loglevel=3 net.ifnames=0
```

## 其他

```bash
$ sudo sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

$ sudo sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

$ sudo sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
```

* https://github.com/DieterReuter/workshop-raspberrypi-64bit-os
* https://github.com/bamarni/pi64/
* https://vuepress.mirror.docker-practice.com/install/raspberry-pi/
* 刷机工具 https://www.balena.io/etcher/
