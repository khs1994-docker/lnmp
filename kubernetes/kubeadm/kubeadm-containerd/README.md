# kubeadm + containerd

kubeadm 默认运行时为 docker,这里简要介绍如何改为 `containerd`

1. 下载 containerd 1.4.x `$ ./lnmp-k8s _containerd_install`
2. 复制 `kubeadm-containerd.service` 到 `/etc/systemd/system/` 并调整配置（cri-containerd 的绝对路径）
3. 复制 `config.toml` 到 `/etc/kubernetes/kubeadm-containerd-config.toml`
4. 执行 `$ sudo systemctl daemon-reload`

> 以上步骤为配置 `containerd`

5. 停止 `kubelet` `docker`
6. 编辑 `/var/lib/kubelet/kubeadm-flags.env`

```diff
- KUBELET_KUBEADM_ARGS="--cgroup-driver=systemd --network-plugin=cni --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.2"
+ KUBELET_KUBEADM_ARGS="--cgroup-driver=systemd --container-runtime=remote --container-runtime-endpoint=unix:///run/kubeadm-containerd/containerd.sock"
```

7. 重启机器
8. 启动 `kubeadm-containerd` `kubelet`
9. 启动 Docker, 清理原来的容器 `$ docker container prune`
10. 部分 pod 等可能出错，删除之后重新部署

以上介绍如何更改运行时，或者在执行 `init` 或 `join` 命令时加上 `--cri-socket=unix:///run/kubeadm-containerd/containerd.sock` 使用 containerd。

## crictl

在 `/etc/crictl.yaml` 自行配置。
