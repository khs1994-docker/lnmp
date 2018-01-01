# Docker for Mac 支持 k8s

启用 `k8s` 之后，输入如下命令

```bash
$ docker stack deploy -c docker-k8s.yml lnmp

$ docker stack services lnmp

$ kubectl get services

$ kubectl get pod

$ docker stack rm lnmp
```

# kubernetes

## 创建数据卷

```bash
$ kubectl create -f lnmp-volumes.yaml

$ kubectl get pv
```

## 创建 config

```bash
$ kubectl create -f lnmp-env.yaml

$ kubectl describe configmap lnmp-env
```

## 创建 secret

```bash
$ kubectl create secret generic lnmp-mysql-password --from-literal=password=mytest

$ kubectl get secrets
```

## 部署

```bash
$ kubectl create -f lnmp-mysql.yaml

$ kubectl create -f lnmp-redis.yaml

$ kubectl create -f lnmp-php7.yaml

$ kubectl create -f lnmp-nginx.yaml
```

## 删除

```bash
$ kubectl delete deployment -l app=lnmp

$ kubectl delete service -l app=lnmp

$ kubectl delete pvc -l app=lnmp

$ kubectl delete pv lnmp-mysql-data lnmp-redis-data

$ kubectl delete secret lnmp-mysql-password

$ kubectl delete configmap lnmp-env
```
