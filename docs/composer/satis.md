# Satis

* https://github.com/khs1994-docker/lnmp/issues/479

* https://github.com/composer/satis

* https://docs.phpcomposer.com/articles/handling-private-packages-with-satis.html

```bash
$ lnmp-docker satis
```

> 若 Git 仓库为 GitHub, API 调用有限制，需要输入 GitHub Token(自行生成)。

## Usage

```json
{
    "repositories": [ { "type": "composer", "url": "http://packages.example.org/" } ],
    "require": {
        "company/package": "1.2.0",
        "company/package2": "1.5.2",
        "company/package3": "dev-master"
    }
}
```
