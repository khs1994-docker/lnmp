* https://github.com/kubernetes/ingress-nginx/tree/master/deploy/static/provider/cloud

```yaml
- name: proxied-udp-53
  port: 53
  targetPort: 53
  protocol: UDP
  nodePort: 53
- name: proxied-tcp-53
  port: 53
  targetPort: 53
  protocol: TCP
  nodePort: 53
```
