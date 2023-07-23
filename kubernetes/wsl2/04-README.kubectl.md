# kubectl

## 在 `WSL2` 中执行

```bash
$ wsl -d wsl-k8s

$ kubectl
```

## 在 `Windows` 中执行

```powershell
$ ./wsl2/bin/kubectl-config-set-cluster

$ kubectl
```

## 切换到其他 context

```bash
$ kubectl config get-contexts

$ kubectl config use-context wsl2
```
