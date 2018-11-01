# Nginx Ingress

* https://kubernetes.github.io/ingress-nginx/deploy/#installation-guide

* https://kubernetes.github.io/ingress-nginx/examples/

* https://blog.csdn.net/aixiaoyang168/article/details/78485581?locationNum=5&fps=1

## 组成

* NGINX 反向代理负载均衡器

* `Ingress Controller` 可以理解为控制器，它通过不断的跟 Kubernetes API 交互，实时获取后端 Service、Pod 等的变化，比如新增、删除等，然后结合 Ingress 定义的规则生成配置，然后动态更新上边的 Nginx 负载均衡器，并刷新使配置生效，来达到服务自动发现的作用。

* `Ingress` 则是定义规则，通过它定义某个域名的请求过来之后转发到集群中指定的 Service。它可以通过 Yaml 文件定义，可以给一个或多个 Service 定义一个或多个 Ingress 规则。

```bash
$ kubectl apply -f addons/ingress-nginx/ingress-nginx.yaml

# 裸机 通过 nodeport ，Docker 桌面版使用下一条命令，不要执行这条命令
$ kubectl apply -f addons/ingress-nginx/service-nodeport.yaml

# Docker 桌面版
$ kubectl apply -f addons/ingress-nginx/cloud-generic.yaml
```

## 注意事项

为避免 **切换暴露服务方式** 时频繁切换端口， `ingress-nginx` 默认端口改为 `8080` `8443`

## 定义规则

```bash
$ kubectl apply -f ingress-nginx/my-ingress.yaml
```

## 后端服务是否为 TLS

* https://tonybai.com/2018/06/25/the-kubernetes-ingress-practice-for-https-service/

## Docker Registry Example

```bash
$ kubectl apply -f ingress-nginx/registry.example.yaml

$ kubectl apply -f ingress-nginx/ingress.example.yaml
```
