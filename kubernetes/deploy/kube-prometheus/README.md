# kube-prometheus

## 部署

```bash
$ git clone --depth=1 git@github.com:coreos/kube-prometheus.git
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

## 监控对象

查看 `custom` 文件夹内容

## 默认只监控 `kube-system` 和 `monitoring` NS 中的服务

具体参考 `custom/XXX/rbac.yaml`，必须使用 `$ kubectl apply -f custom/xxx/rbac.yaml` 应用。

## Grafana

* https://grafana.com/grafana/dashboards

## 参考

* https://www.jianshu.com/p/2fbbe767870d
* https://www.cnblogs.com/tchua/articles/11177045.html
