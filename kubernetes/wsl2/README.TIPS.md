# Tips

## 关闭 WSL2

```powershell
$ wsl --shutdown
```

## kubelet 出错

```bash
$ wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT:-/opt/k8s}/conf/kubelet-bootstrap.kubeconfig
```

## 将某域名解析到 WSL2

在 `.env.ps1` 中设置 `WSL2_DOMAIN` 变量，之后执行 `./wsl2/bin/wsl2host --write`

## debug pod

使用 `circtl`

```powershell
$ ./wsl2/bin/crictl
```
