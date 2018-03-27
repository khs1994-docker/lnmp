# MySQL 一主两从集群

主负责写，两从负责读

## 开发环境

```bash
# 创建集群，若加上 -d 参数表示后台运行。

$ ./lnmp-docker.sh clusterkit-mysql-up [-d]

# 销毁集群，若加上 -v 参数会销毁数据卷。

$ ./lnmp-docker.sh clusterkit-mysql-down [-v]
```

### Swarm mode

```bash
# 创建集群

$ ./lnmp-docker.sh clusterkit-mysql-deploy

# 销毁集群

$ ./lnmp-docker.sh clusterkit-mysql-remove
```

# PHP 连接集群

主服务器 `root` 账号

从服务器 `node` 账号（拥有只读权限）
