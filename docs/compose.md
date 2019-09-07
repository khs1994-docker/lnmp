# Docker Compose

* https://docs.docker.com/compose/compose-file/
* https://blog.csdn.net/chenqijing2/article/details/79506991

`环境变量` 优先级大于 `.env` 文件。

## vars

* `${VARIABLE:-default}` evaluates to default if VARIABLE is unset or empty in the environment.

* `${VARIABLE-default}` evaluates to default only if VARIABLE is unset in the environment.

Similarly, the following syntax allows you to specify mandatory variables:

* `${VARIABLE:?err}` exits with an error message containing err if VARIABLE is unset or empty in the environment.

* `${VARIABLE?err}` exits with an error message containing err if VARIABLE is unset in the environment.

## macOS

* `consistent`: 或者 default：完全一致的默认设置，如上所述。
* `delegated`：容器运行时的挂载视图是权威的。在容器中进行的更新可能在主机上可见之前可能会有延迟。
* `cached`：macOS 主机的挂载视图是权威的。在主机上进行的更新在容器中可见之前可能会有延迟。
