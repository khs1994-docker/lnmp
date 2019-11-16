# Minikube 部署 kubernetes

* https://github.com/AliyunContainerService/minikube

* https://yq.aliyun.com/articles/221687

## 安装

```bash
$ GOOS=linux # darwin
$ MINIKUBE_VERSION=1.3.1
$ url=http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-${GOOS}-amd64

$ sudo curl -L $url -o /usr/local/bin/minikube
```

## 启动

```bash
# macOS
$ minikube start \
  -v 10 \
  --registry-mirror=https://dockerhub.azk8s.cn \
  --vm-driver="hyperkit" \
  --memory=4096

# linux
$ minikube start \
  -v 10 \
  --registry-mirror=https://dockerhub.azk8s.cn \
  --vm-driver="none"
```

```bash
$ minikube service nginx --url

http://192.168.64.98:32228
http://192.168.64.98:30626

$ curl http://192.168.64.98:30626
```

## 挂载宿主机目录

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
