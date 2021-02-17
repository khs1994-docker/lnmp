# Docker 常用镜像站点

> 有时部分镜像可能不可用，请尝试另一个即可。

* https://github.com/ustclug/mirrorrequest/issues?utf8=%E2%9C%93&q=gcr

* `https://hub-mirror.c.163.com`
* `https://mirror.baidubce.com`
* `https://docker.mirrors.ustc.edu.cn`

## gcr.io k8s.gcr.io

* `k8s.gcr.io/xxx` 对应 `gcr.io/google-containers/xxx`

* `https://gcr.mirrors.ustc.edu.cn`
* `registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.1`

```bash
$ docker pull k8s.gcr.io/pause:3.2
$ docker pull gcr.io/google-containers/pause:3.2
$ docker pull gcr.mirror/google-containers/pause:3.2
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2
```

## quay.io

## mcr.microsoft.com

* https://github.com/microsoft/containerregistry/blob/master/docs/mcr-endpoints-guidance.md
