# loop 设备及 losetup 命令介绍

* https://blog.csdn.net/ustc_dylan/article/details/6878252

## loop 设备介绍

在类 UNIX 系统里，loop 设备是一种伪设备(pseudo-device)，或者也可以说是仿真设备。它能使我们像块设备一样访问一个文件。

在使用之前，一个 loop 设备必须要和一个文件进行连接。这种结合方式给用户提供了一个替代块特殊文件的接口。因此，如果这个文件包含有一个完整的文件系统，那么这个文件就可以像一个磁盘设备一样被 mount 起来。

上面说的文件格式，我们经常见到的是 CD 或 DVD 的 ISO 光盘镜像文件或者是软盘(硬盘)的 *.img 镜像文件。通过这种 loop mount (回环mount)的方式，这些镜像文件就可以被 mount 到当前文件系统的一个目录下。

至此，顺便可以再理解一下 loop 之含义：对于第一层文件系统，它直接安装在我们计算机的物理设备之上；而对于这种被 mount 起来的镜像文件(它也包含有文件系统)，它是建立在第一层文件系统之上，这样看来，它就像是在第一层文件系统之上再绕了一圈的文件系统，所以称为 loop。

## `losetup` 命令

```bash
$ losetup [ -e encryption ] [ -o offset ] loop_device file

$ losetup [ -d ] loop_device
```

此命令用来设置循环设备。循环设备可把文件虚拟成块设备，籍此来模拟整个文件系统，让用户得以将其视为硬盘驱动器，光驱或软驱等设备，并挂入当作目录来使用。

上面，命令格式中的选项与参数名：
**-e** 表示加密的方式
**-o** 设置数据偏移量
**-d** 卸载设备

**loop_device** 循环设备名，在 linux 下如 `/dev/loop0` , `/dev/loop1` 等。

**file** 要与循环设备相关联的文件名，这个往往是一个磁盘镜象文件，如 `*.img`

## 使用举例

创建空的磁盘镜像文件，这里创建一个 1.44M 的软盘

```bash
$ dd if=/dev/zero of=floppy.img bs=512 count=2880
```

使用 `losetup` 将磁盘镜像文件虚拟成快设备

```bash
$ losetup /dev/loop1 floppy.img
```

挂载块设备

```bash
$ mount /dev/loop0 /tmp
```

经过上面的三步之后，我们就可以通过 `/tmp` 目录，像访问真实快设备一样来访问磁盘镜像文件`floppy.img`。

卸载 loop 设备

```bash
$ umount /tmp

$ losetup -d /dev/loop1
```
