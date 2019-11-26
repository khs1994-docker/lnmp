# [Harbor](https://github.com/goharbor/harbor)

* 用户名 `admin` 密码 `Harbor12345`
* web 界面使用 `chrome` 打开，`firefox` 打不开（笔者测试）

## Helm

```bash
$ helm repo add harbor https://helm.goharbor.io

$ helm template harbor/harbor
```

## Redis

自行部署，之后替换（示例复用了 Drone 的 Redis）

* redis.ci.svc.cluster.local

## TLS

```bash
$ cd secret/harbor-notary-server

$ cat issue.json | cfssl gencert -config=ca-config.json -ca=ca.crt -ca-key=ca-key.pem -profile=harbor - \
  | cfssljson -bare tls

# tls.pem 改名为 tls.crt
# tls-key.pem 改名为 tls.key
```

## 替换

* `harbor.t.khs1994.com:28443`
* `harbor.t.khs1994.com`
