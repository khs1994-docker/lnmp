## 安装

* https://ubuntu.com/server/docs/virtualization-virt-tools

```bash
apt install libvirt-daemon-system
apt install virtinst
systemctl start libvirtd
```

## 配置修改

```bash
# /etc/libvirt/qemu.conf
user = "root"

group = "root"
```

## 常用命令

```bash
virsh list --all
```

## 磁盘

```bash
qemu-img create -f raw test_add.img 10G
# qemu-img create -f qcow2 image2.qcow2 10G
# qemu-img create -f qcow2 -b fedora-coreos-qemu.qcow2 my-fcos-vm.qcow2
virsh attach-disk fcos-test-01 /home/p_w_picpaths/test_add.img vdb --cache none
# 虚拟机内执行
fdisk -l
mkfs.ext4 /dev/vdb
mkdir   /mnt/test
mount /dev/vdb /mnt/test
```

## 网络

**从配置文件新建网络**

```bash
virsh net-define 网络配置文件.xml
# /usr/share/libvirt/networks/default.xml
# /etc/libvirt/qemu/networks/default.xml
```

```xml
<network>
  <name>vir-nat1</name>
  <bridge name="vir-nat1">
  <forward mode='nat'/>
  <ip address="192.168.57.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.57.2" end="192.168.57.254"/>
    </dhcp>
</network>
```

```bash
virsh net-list --all
virsh net-start default
virsh net-autostart vir-nat1
```

```bash
# 桥接
virsh attach-interface --domain fcos-test-01 --type bridge --source br0 --config
# NAT
virsh attach-interface --domain fcos-test-01 --type network --source vir-nat1 --config
# 删除
virsh detach-interface fcos-test-01 bridge 52:54:00:31:1b:18 --config
```
