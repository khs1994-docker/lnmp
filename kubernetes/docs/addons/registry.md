# [Registry](https://docs.docker.com/registry/configuration/)

## 部署

```bash
$ kubectl apply -k deploy/registry/overlays/development
```

## Ingress

```bash
$ kubectl apply -k ingress/nginx/registry
```

## 测试

`https://registry.t.khs1994.com:{INGRESS_HTTPS_PORT}`

## [自签名证书](https://docs.lnmp.khs1994.com/registry.html)

### Containerd(必须为 1.3+ 版本以上)

* https://github.com/containerd/cri/blob/master/docs/registry.md#configure-registry-tls-communication
