# KhsCI EE

* https://github.com/khs1994-php/khsci

私有部署 **KhsCI EE**

准备好网站 SSL 证书，之后将公钥 + 私钥复制到 `ssl/ci.crt` **一个文件** 中

在 `conf` 文件夹内修改 NGINX 配置文件 `khsci.conf` 中的 **端口号** 及 **域名**。

即，文件结构如下

```bash
.
├── conf
│   ├── khsci.conf
│   └── khsci.config (demo file)
└── ssl
    └── ci.crt
```

## 新建 GitHub App

## 配置 KhsCI

修改 `lnmp/app/khsci/public/.env.production` 文件中的变量。

以上两步详情，请查看 https://github.com/khs1994-php/khsci/blob/master/docs/install/ee.md

## 启动

之后执行以下命令启动 `KhsCI EE`

```bash
$ lnmp-docker.sh khsci-up
```

## 使用

Git 仓库安装你新建的 GitHub App，项目根目录包含 `.khsci.yml` 文件，即可开始使用。

## 如何编写 `.khsci.yml` 文件

请查看 https://github.com/khs1994-php/khsci/blob/master/docs/SUMMARY.md#usage
