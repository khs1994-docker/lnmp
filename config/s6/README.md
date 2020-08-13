# s6

* https://github.com/just-containers/s6-overlay
* https://github.com/skarnet/s6

`/etc/cont-finish.d` 挂载到容器的 `/etc/cont-finish.d`

`/etc/cont-init.d` 挂载到容器的 `/etc/cont-init.d`

`/etc/fix-attrs.d` 挂载到容器的 `/etc/fix-attrs.d`

`/etc/services.d` 挂载到容器的 `/etc/services.d`

## 文件作用

`run`     服务如何启动

`down`    如果 `down` 文件存在，则 S6 不会启动该服务

`finish`  程序退出后的操作

`log/run` 启动日志服务

## env

默认的 `S6_KEEP_ENV` 为 `0`，意味着各个脚本将无法使用环境变量。你可以将其设置为 `1`，或者脚本以 `#!/usr/bin/with-contenv sh` 开头。

## 参考链接

* https://gist.github.com/snakevil/f14d22efcf5d7128dee6b2712bfccf00
* https://blog.csdn.net/M2l0ZgSsVc7r69eFdTj/article/details/78929491
