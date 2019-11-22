# 更新证书

由于特殊原因，我们需要更新 k8s 所用的证书

```bash
$ wsl

$ set -x
$ source wsl2/.env

$ sudo cp -a wsl2/certs ${K8S_ROOT:?err}/
$ sudo mv ${K8S_ROOT:?err}/certs/*.yaml ${K8S_ROOT:?err}/conf
$ sudo mv ${K8S_ROOT:?err}/certs/*.kubeconfig ${K8S_ROOT:?err}/conf
```
