## 申请 SSL 证书

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

第一种方法是自行到国内云服务商等处申请 SSL 证书。

你也可以使用以下命令申请（由 [acme.sh](https://github.com/acmesh-official/acme.sh) 提供技术支持，感谢 [Let's Encrypt](https://letsencrypt.org/)）。

## 通配符证书

Let's Encrypt 现已支持通过 DNS 验证来申请通配符证书，本例以通配符证书为例。

## 确定域名的 DNS 服务商

在 https://github.com/acmesh-official/acme.sh/tree/master/dnsapi 找到自己域名的 DNS 服务商代码，例如

* `dnspod.cn` 代码为 `dns_dp`

* `GoDaddy.com` 代码为 `dns_gd`

...

## 修改 .env 文件

根据 DNS 服务商，自行在 `.env` 文件设置相关变量

* dnspod.cn

  ```bash
  # [DNSPOD]
  DNS_TYPE=dns_dp

  DP_Id=
  DP_Key=
  ```

* GoDaddy.com

  ```bash
  # DNS 服务商
  DNS_TYPE=dns_gd

  GD_Key=sdf...
  GD_Secret=sdf...
  ```

...

### 申请网站证书

除了 `acme.sh` 原始参数外，支持以下参数

* `--httpd`

* `--rsa`

```bash
$ ./lnmp-docker ssl example.com -d *.example.com -d t.example.com -d *.t.example.com [--debug]
```

> 特别提示，`*.example.com` 的证书不支持 `example.com` 所以一个主域要写两次

> 特别提示，第一个网址不用加 `-d` 参数，后面的需要加 `-d` 参数

若你的网站服务器不是 NGINX 而是 HTTPD，那么请加上 `--httpd` 参数，即

```bash
$ ./lnmp-docker ssl example.com -d *.example.com --httpd
```

默认申请 `ECC` 证书，你可以加上 `--rsa` 来申请 RSA 证书，即

```bash
$ ./lnmp-docker ssl example.com -d *.example.com --rsa
```

### 生成证书的位置

`./config/nginx/ssl/*`

## 其他

### 签发自签名证书

```bash
$ ./lnmp-docker ssl-self khs1994.com *.khs1994.com 127.0.0.1 localhost
```

生成的 ssl 文件位于 `./config/nginx/ssl-self`。

务必在浏览器导入根证书（`./config/nginx/ssl-self/root-ca.crt`）。

> `https://*.t.khs1994.com` 均指向 `127.0.0.1` 你可以使用这个网址测试 `https`。

## 示例配置

请查看 `./config/nginx/demo-*.conf`

## 第三方工具

* https://zerossl.com/

## HTTP3

* https://github.com/khs1994-docker/nginx

# More Information

* https://letsencrypt.org/docs/client-options/

* https://github.com/khs1994-website/server-side-tls

* https://github.com/khs1994-docker/tls
