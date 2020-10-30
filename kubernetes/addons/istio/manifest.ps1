istioctl manifest generate --set profile=demo `
  --set components.cni.enabled=true `
  --set values.cni.cniBinDir=/opt/k8s/opt/cni/bin `
  --set values.cni.cniConfDir=/opt/k8s/etc/cni/net.d `
  --set values.meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY `
  --set values.global.proxy.includeIPRanges="10.254.0.0/16" `
  --set values.gateways.istio-ingressgateway.type=NodePort `
  --set values.gateways.istio-ingressgateway.autoscaleMax=1 `
  > istio.yaml
