# CHANGELOG

* CRI 默认为 `containerd`, 还有 `crio` `docker` 可供选择

* Kubernetes `1.21.0`

## v1.19.0

* `kubescheduler.config.k8s.io/v1alpha1` 替换为 `kubescheduler.config.k8s.io/v1beta1`
* The Kubelet's `--volume-plugin-dir` option is now available via the Kubelet config file field `VolumePluginDir`.
* `apiregistration.k8s.io/v1beta1` APIService is deprecated in v1.19+, unavailable in v1.22+; use `apiregistration.k8s.io/v1` APIService

## v1.17.0

* `rbac.authorization.k8s.io/v1beta1` RoleBinding is deprecated in v1.17+, unavailable in v1.22+; use `rbac.authorization.k8s.io/v1` RoleBinding

## v1.16.0

* `admissionregistration.k8s.io/v1beta1` ValidatingWebhookConfiguration is deprecated in v1.16+, unavailable in v1.22+; use `admissionregistration.k8s.io/v1`
