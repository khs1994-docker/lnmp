# k8s ci demo

## GITHUB ACTIONS

```bash
$ mkdir k8s-demo

$ cp ${K8S_ROOT}/etc/kubernetes/kubectl.kubeconfig .

# 编辑 kubectl.kubeconfig 将 server: https://xxx 改为公网可访问的地址

$ cat kubectl.kubeconfig | base64
```

* `KUBECTL_KUBECONFIG` secret 的值为上述命令的执行结果
