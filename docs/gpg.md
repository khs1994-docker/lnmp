# Git GPG

* https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification

**Windows**

* https://www.gnupg.org/download/index.html
* https://gpg4win.org/download.html

**Linux**

```bash
$ sudo apt install gnupg
```

```bash
# 生成 key
$ gpg --default-new-key-algo rsa4096 --gen-key

# 列出公钥
$ gpg --list-keys

# 列出私钥
$ gpg --list-secret-keys --keyid-format LONG

sec   rsa4096/<GPG-key-id> 2018-09-15 [SC] [expires: 2020-09-14]
      XXXX
uid                 [ultimate] khs1994 <khs1994@khs1994.com>

# 导出
$ gpg --armor --export <GPG-key-id>

# copy output to github
# https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account
```

## 配置 GIT

```bash
$ git config --global user.signingkey <GPG-key-id>
$ git config --local commit.gpgsign true
# $ git config --global commit.gpgsign true

# Windows 报错
# gpg: directory '/c/Users/<USERNAME>/.gnupg' created
# gpg: keybox '/c/Users/<USERNAME>/.gnupg/pubring.kbx' created
# gpg: skipped "<GPG-key-id>": No secret key
# gpg: signing failed: No secret key
# error: gpg failed to sign the data
# fatal: failed to write commit object
# 解决办法 设置 gpg 绝对路径
# $ git config --global gpg.program "C:\Program Files (x86)\gnupg\bin\gpg.exe"

# Linux 可能会遇到错误
# 在 ~/.bashrc ~/.bash_profile 两个文件中加入 export GPG_TTY=$(tty)

# 签署 commit
$ git commit -S -s -m "your commit message"

# 签署 tag
$ git tag -s mytag

# 查看 tag
$ git tag -v mytag
```

## 备份

备份分为备份公钥和私钥两个部分

**备份公钥：**

```bash
$ gpg -o filename.pub --export <GPG-key-id>
```

如果没有 KeyID 则是备份所有的公钥，-o 表示输出到文件 filename.pub 中，如果加上 -a 参数则输出文本格式的信息，否则输出的是二进制格式信息。

**备份私钥：**

```bash
$ gpg -o filename --export-secret-keys <GPG-key-id>
```

**可以通过以下命令导入**

```bash
$ gpg --import filename
$ gpg --import filename.pub
```

## X.509 Key

* https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/telling-git-about-your-signing-key

git 2.19 +

```bash
$ git config --global gpg.x509.program smimesign
$ git config --global gpg.format x509
```

git 2.18 -

```bash
$ git config --global gpg.program smimesign
```
