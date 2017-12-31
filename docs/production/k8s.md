# Docker for Mac 支持 k8s

启用 k8s 之后，输入如下命令

```bash
$ docker stack deploy -c docker-stack.yml lnmp

$ docker stack services lnmp

$ kubectl get services

$ kubectl get pod
```

# kubernetes

## 创建数据卷

```bash
$ kubectl create -f lnmp-mysql-volumes.yaml

$ kubectl get pv
```

## 创建 config

```bash
$ kubectl create configmap lnmp-php7-env --from-file
```

## 创建 secret

```bash
$ kubectl create secret generic mysql-password --from-literal=password=mytest

$ kubectl get secrets
```

## 部署 MySQL

```yaml
