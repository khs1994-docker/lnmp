# Istio 1.7

* https://github.com/istio

## 部署

**命令举例**

```bash
# https://istio.io/latest/docs/setup/additional-setup/config-profiles/
$ istioctl profile list

$ istioctl manifest generate --set profile=default > istio.yaml

$ istioctl manifest generate --set profile=demo > istio.yaml

# https://istio.io/latest/zh/docs/reference/config/installation-options/
$ istioctl manifest generate --set profile=demo \
  # istio-cni
  --set components.cni.enabled=true \
  --set values.cni.cniBinDir=/opt/k8s/opt/cni/bin \
  --set values.cni.cniConfDir=/opt/k8s/etc/cni/net.d \

  --set values.meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY \
  # pod 可以访问集群内部服务 值为 kube-apiserver --service-cluster-ip-range 参数的值
  --set values.global.proxy.includeIPRanges="10.254.0.0/16" \
  # 若集群支持 LoadBalancer ,则无需使用该 set
  --set values.gateways.istio-ingressgateway.type=NodePort \

  --set values.gateways.istio-ingressgateway.autoscaleMax=1 \

  --set values.gateways.istio-ingressgateway.sds.enabled=true \
```

**部署**

```bash
$ ./manifest.ps1

$ kubectl create ns istio-system

$ kubectl apply -f istio.yaml
```

## 测试

当使用 kubectl apply 来部署应用时，如果 pod 启动在标有 `istio-injection=enabled` 的命名空间中，那么，Istio sidecar 注入器将自动注入 Envoy 容器到应用的 pod 中：

```bash
$ kubectl create ns istio-test
$ kubectl label namespace istio-test istio-injection=enabled

$ kubectl apply -f demo -n istio-test
```

**istio-ingress 端口**

```bash
$ kubectl get service istio-ingressgateway -n istio-system

NAME                   TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                      AGE
istio-ingressgateway   NodePort   10.254.108.59   <none>        15021:49971/TCP,80:19250/TCP,443:10208/TCP,31400:30444/TCP,15443:35362/TCP   122m
```

上面的示例说明端口为 `19250`

访问 `NODE_IP:19250` 测试

`demo` 文件夹中所进行的测试均在 `istio-test` namespace 中进行

* test-routing   **配置请求路由** https://istio.io/latest/zh/docs/tasks/traffic-management/request-routing/
* test-fault-*   **故障注入** https://istio.io/latest/zh/docs/tasks/traffic-management/fault-injection/
* test-shifting  **流量转移** https://istio.io/latest/zh/docs/tasks/traffic-management/traffic-shifting/
* test-timeout   **设置请求超时** https://istio.io/latest/zh/docs/tasks/traffic-management/request-timeouts/
* test-breaking  **熔断** https://istio.io/latest/zh/docs/tasks/traffic-management/circuit-breaking/
* test-mirroring **镜像** https://istio.io/latest/zh/docs/tasks/traffic-management/mirroring/

## egress 控制 pod 访问外部服务

* https://istio.io/latest/zh/docs/tasks/traffic-management/egress/egress-control/

ingress 控制外部到 pod，egress 反过来控制 pod 到外部

`values.meshConfig.outboundTrafficPolicy.mode` 设置为 `REGISTRY_ONLY`，pod 访问不到外部服务 `$ wget https://www.baidu.com` 无法正确执行`wget: server returned error: HTTP/1.1 502 Bad Gateway`

应用访问规则

```bash
$ kubectl apply -f egress/ServiceEntry.yaml -n istio-test
```

`$ wget https://www.baidu.com` 能够正确执行

**允许 pod 访问特定范围的 ​​IP，（例如，集群内部服务）**

`--set values.global.proxy.includeIPRanges="10.254.0.0/16"`

`$ wget --no-check-certificate https://kubernetes.default.svc.cluster.local`

## [integrations](https://istio.io/latest/docs/ops/integrations/)

从 1.7 版本开始不再包含 `kiali` 等组件

**jaeger**

```bash
$ $ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/jaeger.yaml
```

**kiali**

```bash
# 第一次执行可能报错，稍等片刻再执行一次即可
# $ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml

# bash
$ curl https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml | sed -e "s/prometheus:9090/prometheus-k8s.monitoring:9090/g" -e "s/grafana:3000/grafana.monitoring:3000/g" | kubectl apply -f -

# PS1
$ (Invoke-WebRequest https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml).toString().replace('prometheus:9090','prometheus-k8s.monitoring:9090').replace('grafana:3000','grafana.monitoring:3000') | kubectl apply -f -
```

**Grafana**

使用 `kube-prometheus`

* https://istio.io/latest/docs/ops/integrations/grafana/#configuration

* **7639 Mesh Dashboard** provides an overview of all services in the mesh.
* **7636 Service Dashboard** provides a detailed breakdown of metrics for a service.
* **7630 Workload Dashboard** provides a detailed breakdown of metrics for a workload.
* **11829 Performance Dashboard** monitors the resource usage of the mesh.
* **7645 Control Plane Dashboard** monitors the health and performance of the control plane.

**prometheus**

使用 `kube-prometheus` 参考 `deploy/kube-prometheus/kustomize/istio`

## 参考

* https://my.oschina.net/u/2306127/blog/3234527
* https://github.com/istio/istio/issues/22463
