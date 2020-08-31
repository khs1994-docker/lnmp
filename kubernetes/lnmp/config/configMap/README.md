# How create ConfigMap

```bash
$ kubectl create configmap my-config --from-literal=special.how=very

$ kubectl create configmap my-config --from-file=example.conf --from-file=key=filename

# k=v file
$ kubectl create configmap my-config --from-env-file=.env.example
```

```bash
$ kubectl create configmap lnmp-mysql-cnf --from-file=/path/my.cnf

$ kubectl create configmap lnmp-nginx-conf --from-file=/path/nginx.conf

# 从文件夹创建 configmap
$ kubectl create configmap lnmp-nginx-conf.d --from-file=/nignx-conf-d/path/
```
