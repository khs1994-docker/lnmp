# Release

* 更新 `crictl` 时手动更新 `lnmp-k8s` 脚本中的 crictl sha256sum
* NGINX 更新时 `khs1994-docker/kube-nginx` 打 TAG，CI 构建 `khs1994/kube-nginx:TAG`
* 更新 lwpm k8s 包，commit 包含 [lwpm dist] [k8s]
* 手动触发 [GitHub Action](https://github.com/khs1994-docker/lnmp/actions?query=workflow%3Alwpm-dist-k8s-file) 构建 lwpm k8s 指定版本的镜像
* 同步 lwpm k8s 包到国内镜像，coding.net(由上一步骤的 GitHub Action 自动触发)

## 打包 containerd arm64

在 https://github.com/containerd/containerd/actions 下载

将 `linux_arm64.zip` 放到 `~/lnmp/kubernetes`

```powershell
$ ./lnmp-k8s.ps1 dist-containerd-arm64
```

将 containerd-nightly.linux-arm64.tar.gz 上传到 https://github.com/docker-practice/containerd/releases/tag/nightly

**.tar.gz 文件结构**

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
