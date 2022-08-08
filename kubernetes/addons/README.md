# 插件

* EFK

* metrics-server `0.6.0`

* CoreDNS `1.9.3`

* Dashboard `2.6.0`

* Istio `1.10.0`

## ingress

* ingress-nginx `1.3.0`

* ingress-kong `1.3`

## CNI

* [calico](https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/) `3.23`

## CI/CD

* tekton `0.17.1`

## 目录结构

* `base`
* `cn` 将 `base` 中的 `image` （例如 `k8s.gcr.io`）替换为国内地址
* `kustomization.yaml` 指向 `base`
