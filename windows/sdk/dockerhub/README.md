* https://docs.docker.com/registry/spec/api/#detail
* https://docs.docker.com/registry/spec/manifest-v2-2/

```powershell
[System.Environment]::SetEnvironmentVariable('DOCKER_USERNAME','khs1994','user')

[System.Environment]::SetEnvironmentVariable('DOCKER_PASSWORD','password','your_password')

[System.Environment]::SetEnvironmentVariable('LNMP_CACHE','$HOME\.khs1994-docker-lnmp','user')
```

```powershell
$ . .\windows\sdk\dockerhub\rootfs.ps1

$ rootfs alpine latest amd64 linux
```

```bash
./windows/sdk/dockerhub/rootfs.sh alpine latest amd64 linux
```
