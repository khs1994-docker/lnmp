# WSL2(systemd)

## 启用 systemd

* https://github.com/khs1994-docker/lnmp/blob/19.03/wsl2/README.systemd.md

```diff
# 允许 root 用户
# /usr/sbin/start-systemd-namespace
- if [ "$LOGNAME" != "root" ] && ( [ -z "$SYSTEMD_PID" ] || [ "$SYSTEMD_PID" != "1" ] ); then
+ if [ "$LOGNAME" != "ro4ot" ] && ( [ -z "$SYSTEMD_PID" ] || [ "$SYSTEMD_PID" != "1" ] ); then
```

## 安装

```bash
$ wsl -d wsl-k8s

$ cp -a wsl2/certs/. systemd/certs

$ ./lnmp-k8s _k8s_install_conf_cp
$ ./lnmp-k8s _k8s_install_systemd
```

## 日常使用

```powershell
$ ./wsl2/bin/kube-check

$ ./wsl2/bin/wsl2host-check

$ ./wsl2/bin/wsl2host --write

$ ./wsl2/etcd

$ ./wsl2/kube-wsl2windows k8s
```

**注意事项**

* 不要 enable service (开机自启动)

```powershell
$ Import-Module ./wsl2/bin/WSL-K8S.psm1
$ Get-Command -m wsl-k8s

$ Invoke-WSLK8S ping `$`{WSL2_IP?-wsl2 ip not set`}

$ Invoke-WSLK8S systemctl start kube-apiserver@`$`{WSL2_IP?-wsl2 ip not set`}
$ Invoke-WSLK8S systemctl start kube-controller-manager@`$`{WSL2_IP?-wsl2 ip not set`}
$ Invoke-WSLK8S systemctl start kube-scheduler@`$`{WSL2_IP?-wsl2 ip not set`}

$ Invoke-WSLK8S systemctl start kube-containerd@1.4

# 你也可以执行其他命令供调试
# $ Invoke-WSLK8S CMD
```

**初始化 kubelet**

```powershell
$ ./wsl2/kubelet init
```

**启动 kubelet**

```powershell
$ Invoke-WSLK8S systemctl start kubelet@kube-containerd
```
