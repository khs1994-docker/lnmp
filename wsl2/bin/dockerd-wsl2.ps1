& $PSScriptRoot/../../kubernetes/wsl2/bin/kube-check.ps1

if (!$?) {
  exit 1
}

wsl -d wsl-k8s -u root -- mkdir -p /wsl/wsl-k8s-data/k8s/var/lib/docker

wsl -d wsl-k8s -- sh -c "rm -rf /etc/default/docker"

if (!(Test-Path $PSScriptRoot/../config/etc/docker/daemon.json)) {
  cp $PSScriptRoot/../config/etc/docker/daemon.example.json `
    $PSScriptRoot/../config/etc/docker/daemon.json
}

if (!(Test-Path $PSScriptRoot/../config/etc/default/docker)) {
  cp $PSScriptRoot/../config/etc/default/docker.example `
    $PSScriptRoot/../config/etc/default/docker
}

$DOCKER_DEFAULT_CONFIG_PATH = wsl -d wsl-k8s -- wslpath "'$PSScriptRoot/../config/etc/default/docker'"
$DOCKER_DAEMON_CONFIG_PATH = wsl -d wsl-k8s -- wslpath "'$PSScriptRoot/../config/etc/docker/daemon.json'"

wsl -d wsl-k8s -- cp $DOCKER_DAEMON_CONFIG_PATH /etc/docker/daemon.json
wsl -d wsl-k8s -- cp $DOCKER_DEFAULT_CONFIG_PATH /etc/default/docker

if (!$?) {
  "==> please check WSL [ /etc/default/docker ], see README.DOCKER.md"

  exit 1
}

Function _start() {
  wsl -d wsl-k8s -u root -- service docker start

  $ErrorActionPreference = "continue"

  & $PSScriptRoot/wsl2hostd.ps1 stop

  & $PSScriptRoot/wsl2hostd.ps1 start
}

Function _stop() {
  wsl -d wsl-k8s -u root -- service docker stop
}

switch ($args[0]) {
  start { _start }
  stop { _stop }
  Default {
    "
control Dockerd on WSL2

COMMAND:

start  Start Dockerd on WSL2
stop   Stop  Dockerd on WSL2
"
  }
}
