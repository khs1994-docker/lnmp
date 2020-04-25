* https://docs.docker.com/registry/spec/api/#detail
* https://docs.docker.com/registry/spec/manifest-v2-2/

**设置用户名及密码**

```powershell
[System.Environment]::SetEnvironmentVariable('DOCKER_USERNAME','your_username','user')

[System.Environment]::SetEnvironmentVariable('DOCKER_PASSWORD','your_password','user')

[System.Environment]::SetEnvironmentVariable('LNMP_CACHE','$HOME\.khs1994-docker-lnmp','user')
```

**powershell**

```powershell
# 默认的 163 镜像可能较缓慢，请设置环境变量为阿里云镜像（自行获取）
# $ $env:REGISTRY_MIRROR="xxxx.mirror.aliyuncs.com"

$ . .\windows\sdk\dockerhub\rootfs.ps1

$ rootfs alpine latest amd64 linux
```

**bash**

```bash
# 默认的 163 镜像可能较缓慢，请设置环境变量为阿里云镜像（自行获取）
# $ export REGISTRY_MIRROR=xxxx.mirror.aliyuncs.com

$ ./windows/sdk/dockerhub/rootfs.sh alpine latest amd64 linux
```
