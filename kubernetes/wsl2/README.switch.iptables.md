# switch to legacy iptables

In Linux, **nftables** is available as a modern replacement for the kernel’s **iptables** subsystem. The iptables tooling can act as a compatibility layer, behaving like iptables but actually configuring nftables. This nftables backend is not compatible with the current kubeadm packages: it causes duplicated firewall rules and breaks kube-proxy.

* https://github.com/kubernetes-sigs/iptables-wrappers

* https://github.com/kubernetes/website/pull/19773/files

```bash
# ensure legacy binaries are installed
$ sudo apt-get install -y iptables arptables ebtables
# switch to legacy versions
$ sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
$ sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
$ sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
$ sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```
