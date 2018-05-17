# KhsCI

* https://github.com/khs1994-php/khsci

私有部署 **KhsCI**

准备好网站 SSL 证书，之后将公钥 + 私钥复制 `ssl/ci.crt` **一个文件** 中

在 `conf` 文件夹内修改 NGINX 配置文件 `khsci.conf`

即，文件结构如下

```bash
.
├── conf
│   ├── khsci.conf
│   └── khsci.config (demo file)
└── ssl
    └── ci.crt
```

之后执行以下命令启动 `KhsCI`

```bash
$ lnmp-docker.sh khsci-up
```
