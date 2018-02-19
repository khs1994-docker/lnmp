# Docker Registry

在 `.env` 文件中设置 `KHS1994_LNMP_REGISTRY_HOST` 变量值为 Docker Registry 地址。

> 例如 `docker.t.khs1994.com`，不要添加 `http` 或 `https`。

## 启动

```bash
$ ./lnmp-docker.sh registry
```

第一次执行时，需要输入用户名，密码（**输入两次**）完成初始化设置。

## 停止

```bash
$ ./lnmp-docker.sh registry-down
```
