# Istio 1.6

* https://github.com/istio

## 部署

```bash
# https://istio.io/docs/setup/additional-setup/config-profiles/
$ istioctl profile list

$ istioctl manifest generate --set profile=default > istio.yaml

$ istioctl manifest generate --set profile=demo > istio.yaml

# https://istio.io/zh/docs/reference/config/installation-options/
$ istioctl manifest generate --set profile=demo \
  # istio-cni
  --set components.cni.enabled=true \
  --set values.cni.cniBinDir=/wsl/wsl-k8s-data/k8s/opt/cni/bin \
  --set values.cni.cniConfDir=/wsl/wsl-k8s-data/k8s/etc/cni/net.d \

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
$ kubectl create ns istio-system
$ kubectl apply -f istio.yaml
```

## 测试

当使用 kubectl apply 来部署应用时，如果 pod 启动在标有 `istio-injection=enabled` 的命名空间中，那么，Istio sidecar 注入器将自动注入 Envoy 容器到应用的 pod 中：

```bash
$ kubectl create ns istio-test
$ kubectl label namespace istio-test istio-injection=enabled
```

`demo` 文件夹中所进行的测试均在 `istio-test` namespace 中进行

* test-routing   **配置请求路由** https://istio.io/zh/docs/tasks/traffic-management/request-routing/
* test-fault-*   **故障注入** https://istio.io/zh/docs/tasks/traffic-management/fault-injection/
* test-shifting  **流量转移** https://istio.io/zh/docs/tasks/traffic-management/traffic-shifting/
* test-timeout   **设置请求超时** https://istio.io/zh/docs/tasks/traffic-management/request-timeouts/
* test-breaking  **熔断** https://istio.io/zh/docs/tasks/traffic-management/circuit-breaking/
* test-mirroring **镜像** https://istio.io/zh/docs/tasks/traffic-management/mirroring/

## egress 控制 pod 访问外部服务

* https://istio.io/zh/docs/tasks/traffic-management/egress/egress-control/

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

## 参考

* https://my.oschina.net/u/2306127/blog/3234527
* https://github.com/istio/istio/issues/22463
