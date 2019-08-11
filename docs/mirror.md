# Docker 常用镜像站点

> 有时部分镜像可能不可用，请尝试另一个即可。

* https://github.com/ustclug/mirrorrequest/issues?utf8=%E2%9C%93&q=gcr
* https://www.akscn.io/help/gcr-proxy-cache.html

`https://dockerhub.azk8s.cn`

`https://docker.mirrors.ustc.edu.cn`

`https://reg-mirror.qiniu.com`

`https://hub-mirror.c.163.com`

## gcr.io

### k8s.gcr.io 与 gcr.io 对应关系

`k8s.gcr.io/xxx` 对应 `gcr.io/google-containers/xxx`

### USTC

替换 `gcr.io` 为 `gcr.mirrors.ustc.edu.cn`

替换 `quay.io` 为 `quay.mirrors.ustc.edu.cn`

### 阿里云

```bash
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.1
```

### 七牛云

`https://gcr-mirror.qiniu.com`

`https://quay-mirror.qiniu.com`

### Azure

```bash
$ docker pull gcr.azk8s.cn/google-containers/pause:3.0
```
