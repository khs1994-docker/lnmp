# Git GPG

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

* https://help.github.com/articles/managing-commit-signature-verification/

* Windows https://www.gnupg.org/download/index.html Simple installer for the current GnuPG

```bash
$ gpg --default-new-key-algo rsa4096 --gen-key

# $ gpg --list-keys         #公钥
$ gpg --list-secret-keys --keyid-format LONG # #私钥

sec   rsa4096/<GPG-key-id> 2018-09-15 [SC] [expires: 2020-09-14]
      XXXX
uid                 [ultimate] khs1994 <khs1994@khs1994.com>

$ gpg --armor --export <GPG-key-id>

# copy output to github
# https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/

$ git config --global user.signingkey <GPG-key-id>
$ git config --local commit.gpgsign true
# $ git config --global commit.gpgsign true

# Windows 设置 gpg 绝对路径
# $ git config --global gpg.program "C:\Program Files (x86)\gnupg\bin\gpg.exe"

# Linux 可能会遇到错误
# 在 ~/.bashrc ~/.bash_profile 两个文件中加入 export GPG_TTY=$(tty)

$ git commit -S -s -m "your commit message"

$ git tag -s mytag

$ git tag -v mytag
```

## 备份

备份密钥分为备份公钥和私钥两个部分，备份公钥：

```bash
$ gpg -o keyfilename --export <GPG-key-id>
```

如果没有 KeyID 则是备份所有的公钥，-o 表示输出到文件 keyfilename 中，如果加上 -a 参数则输出文本格式的信息，否则输出的是二进制格式信息。

备份私钥：

```bash
$ gpg -o keyfilename --export-secret-keys <GPG-key-id>
```

然后在别的机器上可以通过

```bash
$ gpg --import filename
```

# X.509 Key

* https://help.github.com/articles/telling-git-about-your-signing-key/#telling-git-about-your-x509-key

git 2.19 +

```bash
$ git config --global gpg.x509.program smimesign
$ git config --global gpg.format x509
```

git 2.18 -

```bash
$ git config --global gpg.program smimesign
```
