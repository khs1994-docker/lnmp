istioctl manifest generate --set profile=demo `
  --set components.cni.enabled=true `
  --set values.cni.cniBinDir=/wsl/wsl-k8s-data/k8s/opt/cni/bin `
  --set values.cni.cniConfDir=/wsl/wsl-k8s-data/k8s/etc/cni/net.d `
  --set values.global.outboundTrafficPolicy.mode=REGISTRY_ONLY `
  --set values.global.proxy.includeIPRanges="10.254.0.0/16" `
  --set values.gateways.istio-ingressgateway.type=NodePort `
  --set values.gateways.istio-ingressgateway.autoscaleMax=1 `
  --set values.gateways.istio-ingressgateway.sds.enabled=true `
  > istio.yaml
