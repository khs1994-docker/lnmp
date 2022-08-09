# 新建 `ext4` 分区

如果硬盘不存在 `ext4` 分区，先在 Windows 磁盘管理中分出一个未分配卷（可以从一个分区中压缩出一个，然后在未分配卷中点击右键选择[新建简单卷]，选择 [不要格式化这个卷]）。然后挂载整块硬盘到 `WSL2`。

```bash
# 请将 PHYSICALDRIVE<N> 替换为具体的值
$ wsl --mount \\.\PHYSICALDRIVE1 --bare
```

挂载之后在 `wsl-k8s` WSL2 发行版中进行格式化。

```bash
$ wsl -d wsl-k8s

# 查看有哪些硬盘

$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 366.8M  1 disk
sdb      8:16   0 232.9G  0 disk
|-sdb1   8:17   0 202.9G  0 part
`-sdb2   8:18   0    30G  0 part
sdc      8:32   0     1T  0 disk /

# sdc 挂载到了 `/` (根目录) 为发行版自身的硬盘
# 再根据硬盘的容量等确定 sdb2 为我们新建的卷，可以格式化为 ext4
# $ mkfs.ext4 /dev/sd<X><P>
# 请将 /dev/sdb2 替换为实际的值
$ mkfs.ext4 /dev/sdb2
```
