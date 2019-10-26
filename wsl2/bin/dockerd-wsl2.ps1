& $PSScriptRoot/../../kubernetes/wsl2/bin/kube-check.ps1

if(!$?){
  exit 1
}

wsl -u root -- mkdir -p /wsl/k8s-data/docker

wsl -- sh -c "cat /etc/default/docker | grep -q '\-\-host tcp://0.0.0.0:2375'"
wsl -- sh -c "cat /etc/default/docker | grep -q '\-\-data\-root=/wsl/k8s-data/docker'"

if(!$?){
  "==> please check WSL [ /etc/default/docker ], see README.DOCKER.md"

  exit 1
}

wsl -u root -- service docker start

$ErrorActionPreference="continue"

& $PSScriptRoot/wsl2hostd.ps1 stop

& $PSScriptRoot/wsl2hostd.ps1 start
