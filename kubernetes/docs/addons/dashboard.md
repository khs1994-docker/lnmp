# 部署 dashboard 插件

```bash
$ kubectl apply -f addons/dashboard.yaml

$ kubectl get deployment kubernetes-dashboard  -n kube-system

$ kubectl --namespace kube-system get pods -o wide

$ kubectl get services kubernetes-dashboard -n kube-system
```

## 通过 kubectl proxy 访问 dashboard

```bash
$ kubectl proxy --address='localhost' --port=8086 --accept-hosts='^*$'
Starting to serve on 127.0.0.1:8086
```

http://127.0.0.1:8086/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy

## 创建登录 token

```bash
$ kubectl create sa dashboard-admin -n kube-system

$ kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin

$ ADMIN_SECRET=$(kubectl get secrets -n kube-system | grep dashboard-admin | awk '{print $1}')

$ DASHBOARD_LOGIN_TOKEN=$(kubectl describe secret -n kube-system ${ADMIN_SECRET} | grep -E '^token' | awk '{print $2}')

echo ${DASHBOARD_LOGIN_TOKEN}
```

## 创建使用 token 的 KubeConfig 文件

```bash
# 设置集群参数
$ kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/certs/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER:-https://192.168.57.110:6443} \
  --kubeconfig=dashboard.kubeconfig

# 设置客户端认证参数，使用上面创建的 Token
$ kubectl config set-credentials dashboard_user \
  --token=${DASHBOARD_LOGIN_TOKEN} \
  --kubeconfig=dashboard.kubeconfig

# 设置上下文参数
$ kubectl config set-context default \
  --cluster=kubernetes \
  --user=dashboard_user \
  --kubeconfig=dashboard.kubeconfig

# 设置默认上下文
$ kubectl config use-context default --kubeconfig=dashboard.kubeconfig
```
