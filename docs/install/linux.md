# Linux/macOS 上安装

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

## 安装

任选其一

### 使用 `git clone`

```bash
$ cd ~

$ git clone --depth=1 https://github.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@github.com:khs1994-docker/lnmp.git

# 中国镜像

$ git clone --depth=1 https://gitee.com/khs1994-docker/lnmp.git

# $ git clone --depth=1 git@gitee.com:khs1994-docker/lnmp
```

### 使用一键安装脚本

```bash
$ cd

$ curl -fsSL lnmp.khs1994.com | sh
```

## 启动 Demo

```bash
$ cd lnmp

$ ./lnmp-docker up
```

浏览器打开 `127.0.0.1`，看到页面。
