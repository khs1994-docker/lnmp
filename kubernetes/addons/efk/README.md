# EFK 插件

* https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch
* https://github.com/opsnull/follow-me-install-kubernetes-cluster/blob/master/08-5.EFK%E6%8F%92%E4%BB%B6.md

## 注意事项

* 推荐宿主机内存 16G

* es 占用内存较大，内存不足会退出，每个 es 实例至少需要 3GB 内存

* es-statefulset.yaml 的 replicas 参数 **不能** 为 1

## 资源占用

`elasticsearch-logging-N` 单个 pod 内存占用 1.5 G。

## 基础知识

* elasticsearch 负责存储日志。

* fluentd 负责将集群中 docker 主机上的日志发送给 elasticsearch，因此 fluentd 在 k8s 集群中需要以 daemonset 的方式运行。

* kibana 负责图形化展示日志信息。

### 部署

```bash
$ kubectl apply -k addons/efk

$ kubectl get pods -n kube-system -o wide|grep -E 'elasticsearch|fluentd|kibana'

$ kubectl cluster-info|grep -E 'Elasticsearch|Kibana'

$ kubectl proxy --address='127.0.0.1' --port=8086 --accept-hosts='^*$'
```

访问 http://127.0.0.1:8086/api/v1/namespaces/kube-system/services/kibana-logging/proxy

## 删除

```bash
$ kubectl delete -k addons/efk
```

## 工具

* https://fluentular.herokuapp.com

## More Information

* https://blog.51cto.com/ylw6006/2071943
* https://www.jianshu.com/p/1000ae80a493
* https://blog.csdn.net/java_zyq/article/details/82179175
