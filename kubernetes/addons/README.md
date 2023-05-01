# 插件

* EFK

* metrics-server `0.6.0`

* CoreDNS `1.10.1`

* Dashboard `2.6.0`

* Istio `1.10.0`

## ingress

* ingress-nginx `1.3.0`

* ingress-kong `2.5.0`

## CNI

* [calico](https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/) `3.24`

## CI/CD

* tekton `0.17.1`

## 目录结构

* `base`
* `cn` 将 `base` 中的 `image` （例如 `registry.k8s.io`）替换为国内地址
* `kustomization.yaml` 指向 `base`
