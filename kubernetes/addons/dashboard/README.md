# dashboard 插件

* https://github.com/kubernetes/dashboard/blob/master/aio/deploy/recommended.yaml

```bash
$ kubectl apply -k addons/dashboard

$ kubectl get all -n kubernetes-dashboard
```

## 通过 kubectl proxy 访问 dashboard

```bash
$ kubectl proxy --address='localhost' --port=8086 --accept-hosts='^*$'
Starting to serve on 127.0.0.1:8086
```

http://127.0.0.1:8086/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy

## 创建登录 token

### Docker 桌面版

* https://github.com/AliyunContainerService/k8s-for-docker-desktop

**macOS**

```bash
$ TOKEN=$(kubectl -n kube-system describe secret default| awk '$1=="token:"{print $2}')

$ kubectl config set-credentials docker-desktop --token="${TOKEN}"
```

**Windows**

```powershell
$ $TOKEN=((kubectl -n kube-system describe secret default | Select-String "token:") -split " +")[1]

$ kubectl config set-credentials docker-desktop --token="${TOKEN}"
```

**登录 dashboard 的时候选择 kubeconfig 文件**

* **macOS** `$HOME/.kube/config`

* **Windows** `%UserProfile%\.kube\config`

### 自行部署的 Kubernetes

```bash
$ kubectl create sa dashboard-admin -n kube-system

$ kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin

$ ADMIN_SECRET=$(kubectl get secrets -n kube-system | grep dashboard-admin | awk '{print $1}')

# PS> $ADMIN_SECRET=(kubectl get secrets -n kube-system | select-string -Pattern dashboard-admin).line.split(' ')[0]

# dashboard-admin-token-nzlbv

$ DASHBOARD_LOGIN_TOKEN=$(kubectl describe secret -n kube-system ${ADMIN_SECRET} | grep -E '^token' | awk '{print $2}')

# PS> $DASHBOARD_LOGIN_TOKEN=(kubectl describe secret -n kube-system ${ADMIN_SECRET} | select-string token:).Line.split(':')[1].trim()

echo ${DASHBOARD_LOGIN_TOKEN}
```

## 创建使用 token 的 KubeConfig 文件

```bash
# 设置集群参数
# Docker desktop k8s
# $ export KUBE_APISERVER=https://localhost:6445
# $ export K8S_ROOT=/opt/k8s

$ kubectl config set-cluster kubernetes \
  --certificate-authority=${K8S_ROOT:-/opt/k8s}/etc/kubernetes/pki/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER:-https://192.168.57.110:6443} \
  --kubeconfig=$HOME/.kube/dashboard.kubeconfig

# 设置客户端认证参数，使用上面创建的 Token
$ kubectl config set-credentials dashboard_user \
  --token=${DASHBOARD_LOGIN_TOKEN} \
  --kubeconfig=$HOME/.kube/dashboard.kubeconfig

# 设置上下文参数
$ kubectl config set-context default \
  --cluster=kubernetes \
  --user=dashboard_user \
  --kubeconfig=$HOME/.kube/dashboard.kubeconfig

# 设置默认上下文
$ kubectl config use-context default --kubeconfig=$HOME/.kube/dashboard.kubeconfig
```
