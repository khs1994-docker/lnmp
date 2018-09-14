# Prometheus Operator

https://github.com/coreos/prometheus-operator/releases

```bash
$ kubectl create namespace monitoring

$ kubectl apply -f bundle.yaml

$ cd contrib/kube-prometheus

$ hack/cluster-monitoring/deploy
```
