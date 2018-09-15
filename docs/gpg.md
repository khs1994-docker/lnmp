# Git GPG

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

# copy print to github
# https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/

$ git config --global user.signingkey <GPG-key-id>
$ git config --local commit.gpgsign true
# $ git config --global commit.gpgsign true

# Windows
# $ git config --global gpg.program "C:\Program Files (x86)\gnupg\bin\gpg.exe"

# 可能会遇到错误
# 在 ~/.bashrc ~/.bash_profile 两个文件中加入 export GPG_TTY=$(tty)

$ git commit -S -m your commit message

$ git tag -s mytag

$ git tag -v mytag
```

## 备份

备份密钥分为备份公钥和私钥两个部分，备份公钥：

```bash
$ gpg -o keyfilename --export <GPG-key-id>
```

如果没有KeyID则是备份所有的公钥，-o表示输出到文件keyfilename中，如果加上-a的参数则输出文本格式的信息，否则输出的是二进制格式信息。

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

2.19 +

```bash
$ git config --global gpg.x509.program smimesign
$ git config --global gpg.format x509
```

2.18 -

```bash
$ git config --global gpg.program smimesign
```
