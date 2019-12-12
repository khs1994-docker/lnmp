# kube-prometheus

## 部署

```bash
$ git clone --depth=1 git@github.com:coreos/kube-prometheus.git
```

```bash
$ kubectl create -f kube-prometheus/manifests/setup

# 等待 20s

$ kubectl create -f kube-prometheus/manifests/
```

## 服务暴露

服务通过 ingress 暴露，可以参考 `ingress` 文件夹中的内容。

* grafana 用户名 `admin` 密码 `admin`

## statefulset.apps/alertmanager-main 启动出错

增加 `pause: true`，适当增加 `livenessProbe` `readinessprobe` 时间 `periodSeconds: 100`

## 动态 PV

参考 `storage/local-path`

## 监控

查看 `custom` 文件夹内容

## 默认只监控 `kube-system` 和 `monitoring` NS 中的服务

## Grafana

* https://grafana.com/grafana/dashboards

## 参考

* https://www.jianshu.com/p/2fbbe767870d
* https://www.cnblogs.com/tchua/articles/11177045.html
