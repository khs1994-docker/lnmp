# 微信小程序 PHP 后端部署

[![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

腾讯云免费提供了微信小程序的测试环境和生产环境，但出现错误排查不了。使用本项目，你也可以轻松部署小程序 PHP 后端。

* 准备网站 `SSL` 证书，假设域名是 `wechat-mini.t.khs1994.com`，上传到服务器 `./app/config/nginx/ssl/` 文件夹下。

* 在提供私有 git 仓库的网站新建名为 `wafer2-quickstart-php` 的仓库，这里以 [TGit](https://git.cloud.tencent.com/) 为例。

* 本地克隆示例项目

进入 `./app`

```bash
$ git clone https://github.com/tencentyun/wafer2-quickstart-php.git

$ cd wafer2-quickstart-php

# 添加远程私有 git 仓库

$ git remote add tgit git@git.qcloud.com:username/wafer2-quickstart-php.git
```

* 使用 `微信开发者工具` 打开项目 `wafer2-quickstart-php`

修改 `server/config.php` 中的各项配置。

修改 `client/config.js` 中的 `host`。

```js
var host = 'https://wechat-mini.t.khs1994.com';
```

* 将代码推送到 git

>由于包含私密信息，务必推送到私有仓库!

```bash
$ git add .

$ git commit -m "Upddate"

$ git push tgit master
```

* 服务器拉取代码

进入 `./app`

```bash
$ git clone git@git.qcloud.com:username/wafer2-quickstart-php.git
```

* 服务器增加 [ `nginx` 配置](https://github.com/khs1994-docker/lnmp-nginx-conf-demo/blob/master/example/demo-wechat-mini.conf)

* 服务器新建数据表

修改 `./backup/mysql/wechat.sql` 里的数据库名

>与 `server/config.php` 中的一致，若数据库不存在，则先新建!

```sql
USE test;
```

```bash
$ ./lnmp-docker restore wechat.sql
```

* `微信开发者工具` 左侧预览区点击登录。

# 生产环境用户

![](https://raw.githubusercontent.com/fans-of-wangxiaochen/cxyl/master/images/cxyl.jpg)

**晨曦雨露**

# More Information

* https://cloud.tencent.com/document/product/619/12797
