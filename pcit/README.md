# PCIT EE

* https://github.com/pcit-ce/pcit

私有部署 **PCIT EE**

准备好网站 SSL 证书，之后将公钥 + 私钥复制到 `ssl/ci.crt` **一个文件** 中

在 `conf` 文件夹内修改 NGINX 配置文件 `pcit.conf` 中的 **端口号** 及 **域名**。

即，文件结构如下

```bash
.
├── conf
│   ├── pcit.conf
│   └── pcit.config
├── key
│   ├── private.key
│   └── public.key
└── ssl
    └── ci.crt
```

## 新建 GitHub OAuth App 和 GitHub App

## 配置 PCIT

修改 `pcit/.env.development` 文件中的变量。

以上两步详情，请查看 https://github.com/pcit-ce/pcit/blob/master/docs/install/ee.md

## 启动

之后执行以下命令启动 `PCIT EE`

```bash
$ lnmp-docker pcit-up
```

## 使用

Git 仓库安装你新建的 GitHub App，项目根目录包含 `.pcit.yml` 文件，即可开始使用。

## 如何编写 `.pcit.yml` 文件

请查看 https://github.com/pcit-ce/pcit/blob/master/docs/SUMMARY.md#usage

# 缓存功能

请配置好 `Minio` 在 `pcit/.env.development` 文件中设置好相关变量即可。
