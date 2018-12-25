# arm64

## 内核启动参数设置

```bash
$ sudo vi /boot/cmdline.txt

dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 cgroup_enable=cpuset cgroup_enable=memory swapaccount=1 elevator=deadline fsck.repair=yes rootwait console=ttyAMA0,115200 kgdboc=ttyAMA0,115200
```

* https://github.com/DieterReuter/workshop-raspberrypi-64bit-os
