# kubectl

## 增加 hosts

执行 kubectl 的主机必须能 ping 通节点,可以在主机增加 `hosts`

```bash
NODE_IP NODE_NAME
```

否则将不能执行 `exec` `port-forward` 等命令.

## run

```bash
$ kubectl run nginx \
    --image=nginx:1.17.5-alpine \
    --command -- cmd arg1 \
    -- arg1 arg2 \
    --port=80
```

## exec

```bash
$ kubectl exec -it nginx -- sh
```

## expose

```bash
$ kubectl expose deployment nginx --port=80 --target-port=80
```

## logs

```bash
$ kubectl logs POD_NAME
```

* https://www.jianshu.com/p/258539db000a

* https://kubernetes.io/zh/docs/user-guide/kubectl-overview/
