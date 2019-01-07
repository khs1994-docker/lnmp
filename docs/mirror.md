# Docker 常用镜像站点

> 有时部分镜像可能不可用，请尝试另一个即可。

* https://github.com/ustclug/mirrorrequest/issues?utf8=%E2%9C%93&q=gcr
* https://www.akscn.io/help/gcr-proxy-cache.html

## gcr.mirrors.ustc.edu.cn

替换 `gcr.io` `k8s.gcr.io` 为 `gcr.mirrors.ustc.edu.cn`

## quay.mirrors.ustc.edu.cn

替换 `quay.io` 为 `quay.mirrors.ustc.edu.cn`

## 阿里云

```bash
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.1
```

## 开源社

```bash
$ docker pull gcr.azk8s.cn/google_containers/pause-amd64:3.0
```
