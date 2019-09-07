# Docker 常用镜像站点

> 有时部分镜像可能不可用，请尝试另一个即可。

* https://github.com/ustclug/mirrorrequest/issues?utf8=%E2%9C%93&q=gcr
* https://www.akscn.io/help/gcr-proxy-cache.html
* https://hub.qiniu.com/home

* `https://dockerhub.azk8s.cn`
* `https://docker.mirrors.ustc.edu.cn`
* `https://reg-mirror.qiniu.com`
* `https://hub-mirror.c.163.com`

## gcr.io k8s.gcr.io

* `k8s.gcr.io/xxx` 对应 `gcr.io/google-containers/xxx`

* `https://gcr.mirrors.ustc.edu.cn`
* `registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.1`
* `https://gcr-mirror.qiniu.com`
* `https://gcr.azk8s.cn`

```bash
$ docker pull k8s.gcr.io/pause:3.0
$ docker pull gcr.io/google-containers/pause:3.0
$ docker pull gcr.azk8s.cn/google-containers/pause:3.0
```

## quay.io

* `https://quay.mirrors.ustc.edu.cn`
* `https://quay-mirror.qiniu.com`
* `https://quay.azk8s.cn`
