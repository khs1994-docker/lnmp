# kube-prometheus

## 部署

```bash
$ git clone --depth=1 git@github.com:prometheus-operator/kube-prometheus
```

```bash
$ kubectl apply -f kube-prometheus/manifests/setup

# 等待 20s

$ kubectl apply -f kube-prometheus/manifests/
```

## 服务暴露

服务通过 **ingress** 暴露，WEB 访问各个服务请查看 `ingress` 文件夹中 `ingress` 配置。

```bash
$ kubectl apply -k ingress
```

* grafana 用户名 `admin` 密码 `admin`

## 动态 PV

参考 `storage/local-path`

```bash
$ kubectl apply -k kustomize/storage
```

## 监控对象

查看 `monitoring-demo` 文件夹内容

## 默认只监控 `kube-system` 和 `monitoring` NS 中的服务

* https://github.com/prometheus-operator/kube-prometheus#adding-additional-namespaces-to-monitor

监控其他命名空间必须应用 RBAC，可以参考 `monitoring-demo/istiod/rbac.yaml`

## Grafana

* https://grafana.com/grafana/dashboards

## 参考

* https://www.jianshu.com/p/2fbbe767870d
* https://www.jianshu.com/p/4b669ef7de4a
* https://www.cnblogs.com/tchua/articles/11177045.html
* https://blog.csdn.net/weixin_34100227/article/details/92270711
