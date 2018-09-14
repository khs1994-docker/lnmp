## 网络出错

原因：没有关闭防火墙，生成了重复的 iptables 规则

清理 `iptables` 规则

* https://blog.csdn.net/shida_csdn/article/details/80028905

```bash
$ systemctl stop kubelet
$ systemctl stop docker

$ iptables --flush
$ iptables -tnat --flush

$ systemctl start kubelet
$ systemctl start docker
```

```bash
$ systemctl stop firewalld && systemctl disable firewalld
$ /usr/sbin/iptables -F && /usr/sbin/iptables -X && /usr/sbin/iptables -F -t nat && /usr/sbin/iptables -X -t nat
$ /usr/sbin/iptables -P FORWARD ACCEPT
$ systemctl daemon-reload && systemctl enable docker && systemctl restart docker
$ for intf in /sys/devices/virtual/net/docker0/brif/*; do echo 1 > $intf/hairpin_mode; done
$ sudo sysctl -p /etc/sysctl.d/kubernetes.conf
```
