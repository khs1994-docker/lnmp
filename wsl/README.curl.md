# curl 部分 https 网站出错

```bash
curl: (35) error:1414D172:SSL routines:tls12_check_peer_sigalg:wrong signature type
```

编辑 `/etc/ssl/openssl.cnf` 最后一行

```diff
-CipherString = DEFAULT@SECLEVEL=2
+CipherString = DEFAULT@SECLEVEL=1
```
