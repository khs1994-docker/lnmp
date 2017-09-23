# 生产环境

* 不启用 `xdebug`

# 个性化配置

务必自定义 `./docker-lnmp.sh`，以实现项目的持续集成/持续部署(CI/CD)。

git clone 本项目，`./app` `./config/nginx` 为空，将项目文件移入（或 git clone ）`./app`，将 nginx 配置文件移入（或 git clone ）`./config/nginx`。
