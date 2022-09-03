* https://projectcalico.docs.tigera.io/maintenance/monitor/monitor-component-metrics

**grafana**

* https://projectcalico.docs.tigera.io/master/manifests/grafana-dashboards.yaml

找到 `felix-dashboard.json`，替换 `calico-demo-prometheus` 为你的 **grafana** 中 **prometheus** 源的名称（例如 `prometheus`）之后粘贴此 JSON 到 grafana 导入框。
