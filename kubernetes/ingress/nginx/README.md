# [Nginx Ingress](https://github.com/kubernetes/ingress-nginx)

* https://kubernetes.github.io/ingress-nginx/deploy/#installation-guide

* https://kubernetes.github.io/ingress-nginx/examples/

* https://blog.csdn.net/aixiaoyang168/article/details/78485581?locationNum=5&fps=1

* https://mritd.me/2017/03/04/how-to-use-nginx-ingress/

## 组成

* NGINX 反向代理负载均衡器

* `Ingress Controller` 可以理解为控制器，它通过不断的跟 Kubernetes API 交互，实时获取后端 Service、Pod 等的变化，比如新增、删除等，然后结合 Ingress 定义的规则生成配置，然后动态更新上边的 Nginx 负载均衡器，并刷新使配置生效，来达到服务自动发现的作用

* `Ingress` 则是定义规则，通过它定义某个域名的请求过来之后转发到集群中指定的 Service。它可以通过 Yaml 文件定义，可以给一个或多个 Service 定义一个或多个 Ingress 规则

## 部署

```bash
# 裸机 通过 nodeport
$ kubectl apply -k addons/ingress/nginx/nodeport

# Docker 桌面版
$ kubectl apply -k addons/ingress/nginx/docker-desktop
```

## 端口

默认没有将 `80` `443` 端口暴露，改为以下端口

* 28080
* 28443

## 定义规则

```bash
$ kubectl apply -k ingress/nginx/lnmp
```

## 后端服务是否为 TLS

* https://tonybai.com/2018/06/25/the-kubernetes-ingress-practice-for-https-service/

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  # https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
  annotations:
    # nginx.ingress.kubernetes.io/secure-backends: "true" # 已废弃
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```

* cli -> (http) -> ingress -> (http) -> backend
* cli -> (https) -> ingress -> (http) -> backend
* cli -> (https) -> ingress -> (https) -> backend

## Docker Registry Example

请参考 `ingress/nginx/registry`

## 4 层代理(tcp udp)

* https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/exposing-tcp-udp-services.md

`tcp-udp`

```bash
$ host -t A nginx.lnmp.svc.cluster.local wsl2.k8s.khs1994.com
```
