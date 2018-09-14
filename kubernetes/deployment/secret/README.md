# How create secret

secret 内容为 base64 编码，所以先将内容 base64 编码之后，复制到指定键值。

```bash
$ echo 'password' | base64

$ cat config/nginx.conf | base64
```

```bash
$ kubectl create secret generic lnmp-nginx-tls --from-file=t.khs1994.com.crt --from-file=t.khs1994.com.key
```
