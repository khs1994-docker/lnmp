# Git Tips

## 更改文件权限

* https://cloud.tencent.com/developer/ask/28981

```bash
$ touch 1.txt

$ git add .

$ git update-index --chmod=+x 1.txt

$ git ls-files --stage

100755 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 0       1.txt
```
