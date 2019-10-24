# WSL2

> 使用 Docker 桌面版启动 WSL2 Docker 或者直接在 WSL2 安装 Docker

由于 Docker 桌面版启动 WSL2 Docker 仍需运行 Docker 桌面版，无端占用资源，实际上完全可以不用 Docker 桌面版。可以在 WSL2 手动安装 Docker，按照 Linux 上安装 Docker 的教程操作即可，这里不再赘述。

## 说明

* Docker 服务端(`dockerd`) 运行于 `WSL2`

## 准备

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

## 2. 配置 Docker

`/etc/default/docker`

```bash
DOCKER_OPTS="--registry-mirror=https://dockerhub.azk8s.cn --host tcp://0.0.0.0:2375 --host unix:///var/run/docker.sock"
```

## 3. 启动 Docker

```bash
# $ wsl -u root -- service docker start

$ ./wsl2/bin/dockerd-wsl2
```

`./wsl2/bin/dockerd-wsl2` 脚本会执行一些初始化命令

* 监听 WSL2 IP 变化,并写入 hosts

## 4. 不要设置 DOCKER_HOST 环境变量

设置过的取消

## 5. 新增 docker context

```bash
$ docker context create wsl2 --description "wsl2" --docker "host=tcp://localhost:2375"
```

## 6. 使用

```bash
$ ./lnmp-docker up
```

## 7. 原理说明

* DOCKER_HOST `tcp://wsl2:2375`
* COMPOSE_CONVERT_WINDOWS_PATHS=1

## 8. 修改 DNS 服务器

`192.168.199.100` Windows IP

## 9. coreDNS

* 编辑 `wsl2/.env.ps1`, 将需要解析到 WSL2 的域名写入。
* `coreDNS` 配置文件 `wsl2/config/coredns/corefile`

```bash
$ ./kubernetes/wsl2/etcd

$ ./wsl2/bin/lnmp-coredns start
```

## 10. vsCode 设置(远程开发)

`文件` -> `首选项` -> `设置` -> `搜索 Docker:host` -> `改为 tcp://wsl2:2375`

```powershell
# $ [environment]::SetEnvironmentvariable("COMPOSE_CONVERT_WINDOWS_PATHS", "1", "User")
```

项目根目录 `.env` 文件增加

```bash
COMPOSE_CONVERT_WINDOWS_PATHS=1
```

## 11. Xdebug

`~/lnmp/.env`

```bash
LNMP_XDEBUG_REMOTE_HOST=wsl2.docker.internal
```
