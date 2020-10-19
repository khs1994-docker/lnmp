# 如何更新

## 修改 `.env`

```bash
KUBERNETES_VERSION=x.y.z
```

## 停止 k8s

```powershell
$ wsl -d wsl-k8s
```

```bash
$ touch /non-systemd
```

```powershell
$ wsl --shutdown
```

## 获取 k8s

```powershell
$ cd ~/lnmp/kubernetes

$ ./wsl2/bin/kube-check

$ wsl -d wsl-k8s
```

```bash
$ ./lnmp-k8s kubernetes-server --url
# $ ./lnmp-k8s kubernetes-server
```

## 更新(复制二进制文件)

```bash
$ ./lnmp-k8s _k8s_install_cp_bin -f

$ rm -rf /non-systemd
```

```powershell
$ wsl --shutdown
```

## 重启 k8s，完成升级
