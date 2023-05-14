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
└── ssl
    └── ci.crt
```

## 新建 GitHub App 并启用 OAuth

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

## 高级配置

### 缓存功能

请配置好 `Minio` 在 `pcit/.env.development` 文件中设置好相关变量即可。

### 运行类别

#### 1. NGINX 代理，一切交由 UNIT 处理（默认方式）`pcit/unit`

该种方式同时运行 `pcitd`，提供了一种快速体验 **PCIT** 的部署方式。

**LNMP_SERVICES**: `pcit`

#### 2. NGINX 代理前端资源，后端交由 UNIT 处理 `pcit/unit`

将前端资源放到 `/app/.pcit/public`，对应的 NGINX 配置文件为 `conf/pcit.proxy.frontend.config`

**LNMP_SERVICES**: `pcit`

#### 3. NGINX 代理前端资源，后端交由 FPM 处理 `pcit/fpm`

将前端资源放到 `/app/.pcit/public`，对应的 NGINX 配置文件为 `conf/pcit.fpm.config`

**LNMP_SERVICES**: `pcit-fpm pcit-server pcit-agent`
