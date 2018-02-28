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

## DashBoard

```bash
$ kubectl apply -f kubernetes-dashboard.yaml

$ kubectl proxy
```

浏览器打开 http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# Kubernetes

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

# Windows 10

Windows 10 在 Hyper-V 虚拟机中运行 Minikube

## 启动

```bash
$ ./minikube.ps1
```

启动之后，手动在 `Hyper-V` 管理界面将 `minikube` 虚拟网络切换到 `默认开关`。

```bash
$ (( Get-VM minikube ).networkadapters[0]).ipaddresses[0]
```

此命令在系统自带的 `PowerShell` 中执行，会获取到 `minikube` 虚拟机 IP.

## 关闭

```bash
$ minikube stop
```

## 移除

```bash
$ minikbe delete
```
