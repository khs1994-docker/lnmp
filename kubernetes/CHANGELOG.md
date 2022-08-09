# CHANGELOG

* CRI 默认为 `containerd`, 还有 `crio` `docker` 可供选择

* Kubernetes `1.22.0`

## v1.24.0

* 不支持 `Docker` Docker runtime support using dockshim in the kubelet is now completely removed in 1.24.

## v1.23.0

* `kubescheduler.config.k8s.io/v1beta1` 替换为 `kubescheduler.config.k8s.io/v1beta3`

## v1.22.0

* `node.k8s.io/v1beta1 RuntimeClass` is deprecated in v1.22+, unavailable in v1.25+

## v1.21.0

* `policy/v1beta1 PodDisruptionBudget` is deprecated in v1.21+, unavailable in v1.25+; use `policy/v1 PodDisruptionBudget`
* `"audit.k8s.io/v1beta1"` is deprecated and will be removed in a future release, use `"audit.k8s.io/v1"` instead
* `discovery.k8s.io/v1beta1 EndpointSlice` is deprecated in v1.21+, unavailable in v1.25+; use `discovery.k8s.io/v1 EndpointSlice`

## v1.19.0

* `kubescheduler.config.k8s.io/v1alpha1` 替换为 `kubescheduler.config.k8s.io/v1beta1`
* The Kubelet's `--volume-plugin-dir` option is now available via the Kubelet config file field `VolumePluginDir`.
* `apiregistration.k8s.io/v1beta1` APIService is deprecated in v1.19+, unavailable in v1.22+; use `apiregistration.k8s.io/v1` APIService
* `spec.template.metadata.annotations[seccomp.security.alpha.kubernetes.io/pod]`: deprecated since v1.19; use the `"seccompProfile"` field instead

## v1.17.0

* `rbac.authorization.k8s.io/v1beta1` RoleBinding is deprecated in v1.17+, unavailable in v1.22+; use `rbac.authorization.k8s.io/v1` RoleBinding

## v1.16.0

* `admissionregistration.k8s.io/v1beta1` ValidatingWebhookConfiguration is deprecated in v1.16+, unavailable in v1.22+; use `admissionregistration.k8s.io/v1`
