# 示例：如何自定义

```yaml
# kustomization.yaml
# 基于 ../overlays/production 进行修改

bases:
- ../overlays/production
```

先看看这个 YAML

```bash
$ kubectl kustomize custom
```

假设我们要修改 MySQL 密码

```yaml
      - env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              key: password
              name: lnmp-mysql-password-ckggtf8tf
```

可以看到密码是通过 `lnmp-mysql-password-ckggtf8tf` 这个 secret 的 `password` 指定的，接下来我们修改 `lnmp-mysql-password` 这个 secret。

```diff
# kustomization.yaml

+ patches:
+ - secret.yaml
```

我们在 `secret.yaml` 文件中重新定义 `lnmp-mysql-password`

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: lnmp-mysql-password
data:
  # mypassword
  password: bXlwYXNzd29yZA==
```

值为 base64 字符串，可以通过以下命令生成

```bash
$ kubectl create secret generic lnmp-mysql-password --from-literal=password=mypassword --dry-run -o yaml
```

通过以上操作，我们把密码定义为了 `mypassword`

## 验证

```bash
$ kubectl apply -k ./custom --dry-run -o yaml
```
