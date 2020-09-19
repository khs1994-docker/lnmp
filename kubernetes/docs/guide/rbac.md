# RBAC

## 新建用户

```bash
# 用户
CN_NAME='username'
# 用户组
O='scope:groupname'

echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"'$O'",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem  \
       -profile=kubernetes - | cfssljson -bare $CN_NAME

$ kubectl config set-cluster myCluster \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kubectl.kubeconfig

$ kubectl config set-credentials $CN_NAME \
  --client-certificate=$CN_NAME.pem \
  --client-key=$CN_NAME-key.pem \
  --embed-certs=true \
  --kubeconfig=kubectl.kubeconfig

$ kubectl config set-context myContext \
  --cluster=myCluster \
  --user=$CN_NAME \
  --kubeconfig=kubectl.kubeconfig

$ kubectl config use-context myContext --kubeconfig=kubectl.kubeconfig
```

下面设置 `scope:groupname` 组的用户只能列出和获取到 `default` 命名空间的 `pod`，其他资源无法获取。

```yaml
# 角色拥有的权限
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: default:pod_get
  namespace: default
rules:
  - apiGroups: [""]
    verbs: ["get","list"]
    resources: ["pods"]
---
# 将用户组与角色绑定
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: default:pod_get
  namespace: default
subjects:
  - kind: Group
    name: scope:groupname
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: default:pod_get
  apiGroup: rbac.authorization.k8s.io
```
