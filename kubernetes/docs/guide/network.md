# 网络出错

原因：没有关闭防火墙，生成了重复的 iptables 规则

清理 `iptables` 规则

* https://blog.csdn.net/shida_csdn/article/details/80028905

```bash
$ sudo systemctl stop kubelet docker

$ sudo iptables --flush
$ sudo iptables -tnat --flush

$ sudo systemctl start docker kubelet
```

```bash
$ sudo systemctl stop firewalld && sudo systemctl disable firewalld
$ sudo /usr/sbin/iptables -F && sudo /usr/sbin/iptables -X && sudo /usr/sbin/iptables -F -t nat && sudo /usr/sbin/iptables -X -t nat
$ sudo /usr/sbin/iptables -P FORWARD ACCEPT
$ sudo systemctl daemon-reload && sudo systemctl enable docker && sudo systemctl restart docker
$ for intf in /sys/devices/virtual/net/docker0/brif/*; do echo 1 > $intf/hairpin_mode; done
$ sudo sysctl -p /etc/sysctl.d/kubernetes.conf
```

## libvirt

* https://serverfault.com/questions/516366/how-virbr0-nic-is-created

```bash
# 临时
$ sudo virsh net-destroy default

# 永久
$ sudo virsh net-autostart default --disable

$ sudo systemctl disable libvirtd.service
```
