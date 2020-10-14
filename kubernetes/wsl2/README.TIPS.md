# Tips

**关闭 WSL2**

```powershell
$ wsl --shutdown
```

**kubelet 出错**

```bash
$ wsl -d wsl-k8s -u root -- rm -rf ${K8S_ROOT:-/opt/k8s}/etc/kubernetes/kubelet-bootstrap.kubeconfig
```

**WSL2 IP 变化造成的 kubelet 报错**

```bash
certificate_manager.go:464] Current certificate is missing requested IP addresses [172.21.21.166]
```

* 每次 IP 变化时删除 `${K8S_ROOT}/etc/kubernetes/pki/kubelet-server-*.pem` 证书.

**将某域名解析到 WSL2**

在 `.env.ps1` 中设置 `WSL2_DOMAIN` 变量，之后执行 `./wsl2/bin/wsl2host --write`

**ps 查看进程关系**

```bash
$ ps aux --forest
```

**某些缺失命令**

* **netstat** `net-tools`
* **ps** `procps`
* **ip** `iproute2`
