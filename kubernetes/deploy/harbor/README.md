# [Harbor](https://github.com/goharbor/harbor)

* web 界面使用 用户名 `admin` 密码 `Harbor12345`
* 首次登录请等待片刻（数据库需要初始化一段时间）

## 准备

复制 `custom` 文件夹为另一个文件夹方便修改（例如 `custom2`），并按如下步骤自行修改后部署

### TLS

```bash
$ cd custom2/secret/harbor-notary-server/certs

$ cat issue.json | cfssl gencert -config=ca-config.json -ca=ca.crt -ca-key=ca-key.pem -profile=harbor - \
  | cfssljson -bare tls

# tls.pem 改名为 tls.crt
# tls-key.pem 改名为 tls.key
```

### 替换

* `harbor.t.khs1994.com:28443`
* `harbor.t.khs1994.com`

## 生成 patch 文件

```bash
$ cd custom2

$ ./generate
```

## 部署

```bash
$ kubectl apply -k custom2
```

访问地址请查看 `custom/ingress.yaml`

## 开发者

从 helm 获取部署文件

```bash
$ helm repo add harbor https://helm.goharbor.io

$ helm repo update

$ helm template harbor/harbor > base/harbor.yaml

# harbor.t.khs1994.com
# notary.t.khs1994.com
# 替换为自己的域名
$ helm template harbor/harbor \
  --set expose.ingress.hosts.core=harbor.t.khs1994.com \
  --set expose.ingress.hosts.notary=notary-harbor.t.khs1994.com \
  --set externalURL=https://harbor.t.khs1994.com:28443 \
  # --set trivy.gitHubToken="your_github_token" \
  > base/harbor.yaml
```

`RELEASE-NAME-` 替换为空
`core.harbor.domain` 替换为自己的域名（e.g.: harbor.t.khs1994.com:28443）

## 使用

* 若使用私有证书请查看 https://docs.lnmp.khs1994.com/registry.html
