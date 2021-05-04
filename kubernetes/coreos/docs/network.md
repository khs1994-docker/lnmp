# 网络配置

## NetworkManager(Fedora)

* `/etc/sysconfig/network-scripts/ifcfg-eth0`

```bash
TYPE=Ethernet
NAME=eth0
DEVICE=eth0
IPADDR={{IP_{{n}}}}
BOOTPROTO=static
ONBOOT=yes
PREFIX=24
GATEWAY=192.168.57.1
```

* https://www.cnblogs.com/baichuanhuihai/p/8127329.html

## NetworkManager(FCOS)

* `/etc/NetworkManager/system-connections/eth1.nmconnection`

```bash
[connection]
id=eth0
interface-name=eth0
type=ethernet
autoconnect=true

[ipv4]
method=manual # auto->dhcp
dns=114.114.114.114
addresses=192.168.57.110/24
gateway=192.168.57.1
```

* https://github.com/coreos/fedora-coreos-tracker/issues/233
* https://github.com/coreos/butane/issues/34
* https://www.cnblogs.com/lcword/p/5917440.html
* https://developer.gnome.org/NetworkManager/

## networkd(CoreOS)

```bash
$ sudo vi /etc/systemd/network/30-static.network

[Match]
Name=eth0

[Network]
# fix me
Address=IP_1/24
DNS=114.114.114.114
Gateway=192.168.57.1

$ sudo systemctl restart systemd-networkd
```
