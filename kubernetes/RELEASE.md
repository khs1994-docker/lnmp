# Release

* 更新 `crictl` 时手动更新 `lnmp-k8s` 中的 crictl sha256sum
* 执行 `cd cli ; sh generate.sh`
* NGINX 更新时 `khs1994-docker/kube-nginx` 打 TAG，CI 构建 `khs1994/kube-nginx:TAG`

## 打包 containerd arm64

在 https://github.com/containerd/containerd/actions 下载

解压 zip , 将文件按如下放置

```bash
containerd-nightly.linux-arm64
└── bin
    ├── containerd
    ├── containerd-shim
    ├── containerd-shim-runc-v1
    ├── containerd-shim-runc-v2
    ├── containerd-stress
    └── ctr
```

打包为 `.tar.gz` 文件

```bash
$ tar -zcvf containerd-nightly.linux-arm64.tar.gz containerd-nightly.linux-arm64
```

上传到 https://github.com/docker-practice/containerd/releases/tag/nightly
