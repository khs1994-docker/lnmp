# WSL2 systemd+k8s 初始化

## 1. 配置 systemd

* https://github.com/khs1994-docker/lnmp/blob/master/wsl2/README.systemd.md

```bash
$ cd ~/lnmp/wsl2/ubuntu-wsl2-systemd-script

$ wsl -d wsl-k8s

$ apt install sudo

$ bash ubuntu-wsl2-systemd-script.sh
```

## 2. 配置 k8s

```bash
$ cd ~/lnmp/kubernetes

$ wsl -d wsl-k8s

$ cp -a wsl2/certs/. systemd/certs

$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_conf_cp
$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_systemd
```
