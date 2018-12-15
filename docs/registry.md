# Docker Registry

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

在 `.env` 文件中设置 `LNMP_REGISTRY_HOST` 变量值为 Docker Registry 地址。

> 例如 `docker.t.khs1994.com`，不要添加 `http` 或 `https`。

## 启动

```bash
$ ./lnmp-docker registry-up
```

第一次执行时，需要输入用户名，密码（**输入两次**）完成初始化设置。

## 停止

```bash
$ ./lnmp-docker registry-down
```
