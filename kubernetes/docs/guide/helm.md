# Helm 3 With TLS

## 安装客户端 helm

* https://github.com/helm/helm

在 GitHub Release 处下载二进制文件，放入 `PATH` 即可

* 需要安装 `socat`，`yum/apt` 直接安装即可

## 初始化

```bash
$ helm init --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```

## Helm 仓库 Charts

* https://github.com/helm/charts
