# CHANGELOG

* CRI 默认为 `containerd`, 还有 `crio` `docker` 可供选择

* Kubernetes `1.18.0`

* Helm 3

## v1.19.0-alpha.2

* `kubescheduler.config.k8s.io/v1alpha1` 替换为 `kubescheduler.config.k8s.io/v1alpha2`
* The Kubelet's `--volume-plugin-dir` option is now available via the Kubelet config file field `VolumePluginDir`.
