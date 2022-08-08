```bash
$ fdisk -l
$ fdisk /dev/sdX
# 自行学习使用 fdisk 命令
$ fdisk /dev/sdX

Welcome to fdisk (util-linux 2.38).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): 输入n
Partition number (5-128, default 5): 按回车
First sector (466944-468862094, default 466944): 按回车
Last sector, +/-sectors or +/-size{K,M,G,T,P} (466944-466489343, default 466489343): 按回车

Created a new partition 5 of type 'Linux filesystem' and of size 222.2 GiB.
Partition #5 contains a ext4 signature.

Do you want to remove the signature? [Y]es/[N]o: 输入yes

The signature will be removed by a write command.

Command (m for help): 输入w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.


$ mkfs.ext4 /dev/sdXN
```
