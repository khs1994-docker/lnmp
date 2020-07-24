# Docker Compose

* https://docs.docker.com/compose/compose-file/
* https://blog.csdn.net/chenqijing2/article/details/79506991

`环境变量` 优先级大于 `.env` 文件。

> Values set in the shell environment override those set in the `.env` file.

## 变量解析

* `${VARIABLE:-default}` evaluates to default if VARIABLE is unset or empty in the environment. 未设置或为空，则为 `default`

* `${VARIABLE-default}` evaluates to default only if VARIABLE is unset in the environment. 未设置，则为 `default`

Similarly, the following syntax allows you to specify mandatory variables:

* `${VARIABLE:?err msg}` exits with an error message containing err if VARIABLE is unset or empty in the environment. 未设置或为空，报错 `err msg`

* `${VARIABLE?err msg}` exits with an error message containing err if VARIABLE is unset in the environment. 未设置，报错 `err msg`

## macOS

* `consistent`: 或者 default：完全一致的默认设置，如上所述。
* `delegated`：容器运行时的挂载视图是权威的。在容器中进行的更新可能在主机上可见之前可能会有延迟。(例如：挂载源代码)
* `cached`：macOS 主机的挂载视图是权威的。在主机上进行的更新在容器中可见之前可能会有延迟。

## $$

```bash
web:
  build: .
  command: "echo $$VAR_NOT_INTERPOLATED_BY_COMPOSE"
```

`$VAR` 都会被 compose 当作变量被解析，可以使用 `$$` 避免被 compose 解析。

## docker stack 不支持 `.env` 文件

## network attachable (swarm mode)

* https://docs.docker.com/compose/compose-file/#attachable
