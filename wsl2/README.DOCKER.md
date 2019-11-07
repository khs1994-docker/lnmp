# WSL2

* 1. 使用 Docker 桌面版启动 WSL2 Docker（在设置中启用）
* 2. 直接在 WSL2 安装 Docker（按照 Linux 上安装 Docker 的教程操作即可，这里不再赘述。）

> 两种方式启动的 Docker 相互冲突，请停止另一个并执行 `$ wsl --shutdown` 后重新启动。

## 说明

* Docker 服务端(`dockerd`) 运行于 `WSL2`
* 数据放到 `k8s-data` WSL2 发行版

## 准备(自定义 DNS 服务器)

* `etcd`
* `coreDNS`

## 功能

* 直接在终端执行 `$ ./lnmp-docker` 无需切换到 WSL2

## 1. 配置 WSL2 中的 Windows 文件挂载路径

`$ sudo vim /etc/wsl.conf`

```bash
[automount]
enabled = true
root = /
```

## 2. [配置 Docker](https://docs.docker.com/engine/reference/commandline/dockerd/)

`/etc/default/docker`

```bash
DOCKER_OPTS="--registry-mirror=https://dockerhub.azk8s.cn --host tcp://0.0.0.0:2375 --host unix:///var/run/docker.sock --data-root=/wsl/k8s-data/docker"
```

## 3. 不要设置 `DOCKER_HOST` 环境变量

设置过的取消

## 4. 新增 docker context

Windows `~/.docker/config.json` 增加 `"experimental": "enabled"`

```bash
$ docker context create wsl2 --description "wsl2" --docker "host=tcp://localhost:2375"

$ docker context use wsl2
```

## 5. 启动 Docker

```bash
# $ wsl -u root -- service docker start

$ ./lnmp-docker dockerd start
```

* 监听 WSL2 IP 变化,并写入 hosts

## 6. 使用

```bash
$ ./lnmp-docker up
```

## 7. 设置 hosts

`kubernetes/wsl2/.env.ps1` 自行添加要解析到 WSL2 的域名

```powershell
$WSL2_DOMAIN="wsl.t.khs1994.com","test2.t.khs1994.com"
```

## 8. 原理说明

* DOCKER_HOST `tcp://wsl2:2375`
* COMPOSE_CONVERT_WINDOWS_PATHS=1

## 9. Xdebug

`~/lnmp/.env`

```bash
LNMP_XDEBUG_REMOTE_HOST=wsl2.lnmp.khs1994.com
```

## 文件权限

由于文件权限问题（例如 Laravel 的 storage 文件夹），部分应用可能会报错，进入 WSL 更改文件权限即可。

## IDE

### vsCode 设置(远程开发)

`文件` -> `首选项` -> `设置` -> `搜索 Docker:host` -> `改为 tcp://wsl2:2375`

```powershell
# $ [environment]::SetEnvironmentvariable("COMPOSE_CONVERT_WINDOWS_PATHS", "1", "User")
```

项目根目录 `.env` 文件增加

```bash
COMPOSE_CONVERT_WINDOWS_PATHS=1
```
