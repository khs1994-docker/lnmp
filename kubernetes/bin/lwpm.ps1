$env:LWPM_DOCKER_REGISTRY="mirror.ccs.tencentyun.com"

./lnmp/windows/lnmp-windows-pm.ps1 add `
  kubernetes-node@1.21.0 `
  --all-platform

$env:LWPM_DOCKER_REGISTRY=$env:LWPM_DOCKER_REGISTRY_MIRROR

./lnmp/windows/lnmp-windows-pm.ps1 push    kubernetes-node@1.21.0
