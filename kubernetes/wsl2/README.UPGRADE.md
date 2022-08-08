# 如何更新

## 修改 `~/lnmp/kubernetes/.env`

```bash
# x.y.z 为 K8S 版本号
KUBERNETES_VERSION=x.y.z
```

## 停止 k8s

```powershell
$ New-Item \\wsl$\wsl-k8s\non-systemd

$ wsl --shutdown
```

## 获取 k8s

```powershell
$ cd ~/lnmp/kubernetes

$ ./wsl2/bin/kube-check

$ wsl -d wsl-k8s -- ./lnmp-k8s kubernetes-server --url
```

## 更新(复制二进制文件)

```bash
$ ./lnmp-k8s _k8s_install_cp_bin -f
```

```powershell
$ Remove-Item \\wsl$\wsl-k8s\non-systemd

$ wsl -d wsl-k8s
```

## 启动 K8S

请查看 [02-README.systemd.md](02-README.systemd.md)
