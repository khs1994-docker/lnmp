## Minikube

* https://www.khs1994.com/docker/minikube/README.html

```bash
$ ./lnmp-k8s minikube-install

# move minikube to your PATH
$ ./lnmp-k8s minikube

# create
$ minikube service nginx --url

http://192.168.64.98:32228
http://192.168.64.98:30626

$ curl http://192.168.64.98:30626
```

#### 挂载宿主机目录

```bash
$ minikube mount ~/lnmp:/data/lnmp
```

#### 关闭 minikube

```bash
$ minikube stop
```

#### 移除 minikube

```bash
$ minikube delete
```
