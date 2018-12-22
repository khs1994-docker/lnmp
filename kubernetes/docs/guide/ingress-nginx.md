# Ingress NGINX

* https://kubernetes.github.io/ingress-nginx/

## 部署

```bash
$ kubectl apply -f addons/ingress-nginx/ingress-nginx.yaml
```

### Docker 桌面版

```bash
$ kubectl apply -f addons/ingress-nginx/cloud-generic.yaml
```

### Linux (自己部署)

```bash
$ kubectl apply -f addons/ingress-nginx/service-nodeport.yaml
```

## 定义规则

参考 `ingress-nginx/lnmp-ingress.yaml`，编写自己的文件，之后应用。

```bash
$ kubectl apply -f ingress-nginx/my-ingress.yaml
```
