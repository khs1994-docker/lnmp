# Satis

* https://github.com/khs1994-docker/lnmp/tree/master/app/satis-demo

* https://github.com/khs1994-docker/lnmp/issues/479

* https://github.com/composer/satis

* https://docs.phpcomposer.com/articles/handling-private-packages-with-satis.html

```bash
$ lnmp-docker satis
```

> 若 Git 仓库为 GitHub, API 调用有限制，需要输入 GitHub Token(自行生成)。

## Usage

`repositories options ssl` 用来配置自签名证书的信息，如果是正规证书，请忽略此项。

* http://www.php.net/manual/en/context.ssl.php

```json
{
    "repositories": [
      {
        "type": "composer",
        "url": "http://packages.t.khs1994.com/",
        "options": {
          "ssl": {
                    "cafile": "/home/path/my-root-ca.crt"
          }
        }
      }
    ],
    "require": {
        "company/package": "1.2.0",
        "company/package2": "1.5.2",
        "company/package3": "dev-master"
    }
}
```
