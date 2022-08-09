# WSL2 systemd+k8s 初始化

* https://github.com/khs1994-docker/lnmp/blob/master/wsl2/README.systemd.md

```bash
$ cd ~/lnmp/wsl2/ubuntu-wsl2-systemd-script

$ wsl -d wsl-k8s -- apt install -y sudo

$ wsl -d wsl-k8s -- bash ubuntu-wsl2-systemd-script.sh
```
