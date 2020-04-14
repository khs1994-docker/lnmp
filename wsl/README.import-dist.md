# 从 Docker rootfs 新建 WSL 发行版

请把 **DIST** 替换为实际的名称

```powershell
$ cd ~/lnmp

$ $env:DOCKER_USERNAME="your_docker_hub_username"
$ $env:DOCKER_PASSWORD="your_docker_hub_password"

$ . ./windows/sdk/dockerhub/rootfs

$ wsl --import DIST `
    C:/DIST `
    $(rootfs alpine) `
    --version 2

# 测试

$ wsl -d DIST

$ uname -a
```
