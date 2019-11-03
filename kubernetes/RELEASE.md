# Release

* 更新 `crictl` 时手动更新 `lnmp-k8s` 中的 crictl sha256sum
* 执行 `cd cli ; sh generate.sh`
* NGINX 更新时 `khs1994-docker/kube-nginx` 打 TAG，CI 构建 `khs1994/kube-nginx:TAG`
