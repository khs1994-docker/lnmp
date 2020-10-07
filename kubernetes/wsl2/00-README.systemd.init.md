# WSL2(systemd)

## 初始化（仅需执行一次）

### 1. 配置 systemd

* https://github.com/khs1994-docker/lnmp/blob/19.03/wsl2/README.systemd.md

```bash
$ cd ~/lnmp/wsl2/ubuntu-wsl2-systemd-script

$ wsl -d wsl-k8s

$ apt install sudo

$ bash ubuntu-wsl2-systemd-script.sh
```

### 2. 安装

```bash
$ wsl -d wsl-k8s

$ cp -a wsl2/certs/. systemd/certs

$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_conf_cp
$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_systemd
```
