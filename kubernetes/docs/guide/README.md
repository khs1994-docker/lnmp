# Kubectl

## run

```bash
$ kubectl run nginx \
    --image=nginx:1.15.12-alpine \
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
