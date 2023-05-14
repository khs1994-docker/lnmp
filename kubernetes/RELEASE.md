# Release

* k8s 新版本发布时（e.g. 1.18.0），tag 上一个版本（e.g. 1.17.0）
* 更新 `crictl` 时手动更新 `lnmp-k8s` 脚本中的 crictl sha256sum
* NGINX 更新时 `khs1994-docker/kube-nginx` 打 TAG，CI 构建 `khs1994/kube-nginx:TAG`
* 更新 lwpm k8s 包，commit 包含 [lwpm dist] [k8s]
* 手动触发 [GitHub Action](https://github.com/khs1994-docker/lnmp/actions?query=workflow%3Alwpm-dist-k8s-file) 构建 lwpm k8s 指定版本的镜像
* 同步 lwpm k8s 包到国内镜像，coding.net(由上一步骤的 GitHub Action 自动触发)

## 国外镜像

默认使用国内镜像，请在 `lnmp-k8s` 中判断运行环境，若为国外环境，执行 `sed` 替换为国外镜像
