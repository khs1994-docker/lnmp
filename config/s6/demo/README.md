# s6-overlay

* https://github.com/just-containers/s6-overlay
* https://github.com/skarnet/s6

`cont-finish.d` 挂载到容器的 `/etc/cont-finish.d`

`cont-init.d` 挂载到容器的 `/etc/cont-init.d`

`fix-attrs.d` 挂载到容器的 `/etc/fix-attrs.d`

`services.d` 挂载到容器的 `/etc/services.d`

默认的 `S6_KEEP_ENV` 为 `0`，意味着各个脚本将无法使用环境变量。你可以将其设置为 `1`，或者脚本以 `#!/usr/bin/with-contenv sh` 开头。
