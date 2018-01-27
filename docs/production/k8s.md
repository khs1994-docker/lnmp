# Docker 桌面版支持 k8s

>更多信息请查看：https://www.khs1994.com/docker/docker-win-k8s.html

启用 `k8s` 之后，输入如下命令

```bash
$ docker stack deploy -c docker-k8s.yml lnmp

$ docker stack services lnmp

$ kubectl get services

$ kubectl get pod
```

## 删除

```bash
$ docker stack rm lnmp
```

# kubernetes

> 这里以 Minikube 为例：https://www.khs1994.com/docker/minikube/README.html

## 挂载宿主机目录

```bash
$ minikube mount ~/lnmp:/data/lnmp
```

## 部署

```bash
$ ./kubernetes.sh deploy

$ minikube service nginx --url

http://192.168.64.98:32228
http://192.168.64.98:30626

$ curl http://192.168.64.98:30626
```

## 删除

```bash
$ ./kubernetes.sh cleanup
```

## 具体命令

请查看 `./kubernetes.sh` 文件内容。
