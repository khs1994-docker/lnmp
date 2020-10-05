# 更新证书

由于特殊原因，我们需要更新 k8s 所用的证书

```bash
$ wsl -d wsl-k8

$ set -x
$ source wsl2/.env

$ sudo cp -a wsl2/certs/. ${K8S_ROOT:?err}/etc/kubernetes/pki/
$ sudo mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.yaml ${K8S_ROOT:?err}/etc/kubernetes
$ sudo mv ${K8S_ROOT:?err}/etc/kubernetes/pki/*.kubeconfig ${K8S_ROOT:?err}/etc/kubernetes
```
