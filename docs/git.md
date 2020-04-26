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

## 撤销

**撤销 commit**

```bash
$ git reset --soft HEAD^
```

**撤销暂存**

```bash
$ git reset HEAD 文件名
```

## 提交到了错误分支

```bash
# 撤销 commit 之后

$ git stash

# 切到正确分支
$ git checkout 18.09

$ git stash pop

$ git add .
```

## CRLF(Win) LF(Unix)

**提交时转换为LF，检出时转换为CRLF**

```bash
$ git config --global core.autocrlf true
```

**提交时转换为LF，检出时不转换(推荐设置)**

```bash
$ git config --global core.autocrlf input
```

**提交检出均不转换**

```bash
$ git config --global core.autocrlf false
```

**拒绝提交包含混合换行符的文件**

```bash
$ git config --global core.safecrlf true
```

**允许提交包含混合换行符的文件**

```bash
$ git config --global core.safecrlf false
```

**提交包含混合换行符的文件时给出警告**

```bash
$ git config --global core.safecrlf warn
```

## 重写 committer

```bash
$ git commit --amend --reset-author
```

## 拉取 tag、pull_request

```bash
$ git fetch origin refs/tags/v18.09.0
# 默认拉取到 FETCH_HEAD，你可以在后边加 `:branch` 拉取到指定分支。

$ git fetch origin refs/pull/1/head:pull_request
```

## TOOLS

* [github/git-sizer](https://github.com/github/git-sizer)

* [github/hub](https://github.com/github/hub)

* [git-lfs/git-lfs](https://github.com/git-lfs/git-lfs)

## 跳过 SSL 验证（使用自签名证书）

```bash
$ git config http.sslverify false
```
