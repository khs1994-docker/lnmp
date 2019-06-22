# arm64

## 内核启动参数设置

```bash
$ sudo vi /boot/cmdline.txt

dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory swapaccount=1 elevator=deadline fsck.repair=yes rootwait console=ttyAMA0,115200 kgdboc=ttyAMA0,115200
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
* https://docker_practice.gitee.io/install/raspberry-pi.html
* 刷机工具 https://www.balena.io/etcher/
