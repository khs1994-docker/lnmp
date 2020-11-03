<#
.SYNOPSIS
  lnmp k8s CLI
.DESCRIPTION
  lnmp k8s CLI

  $ ./lnmp-k8s

.INPUTS

.OUTPUTS

.NOTES

#>
cd $PSScriptRoot

################################################################################

$KUBECTL_URL = "https://storage.googleapis.com/kubernetes-release/release"
$KUBECTL_URL = "https://mirror.azure.cn/kubernetes/kubectl"

################################################################################

if (!(Test-Path .env.ps1 )) {
  cp .env.example.ps1 .env.ps1
}

if (!(Test-Path .env )) {
  cp .env.example .env
}

if (!(Test-Path coreos/.env )) {
  cp coreos/.env.example coreos/.env
}

if (!(Test-Path wsl2/.env )) {
  cp wsl2/.env.example wsl2/.env
}

if (!(Test-Path wsl2/.env.ps1 )) {
  cp wsl2/.env.example.ps1 wsl2/.env.ps1
}

if (!(Test-Path systemd/.env )) {
  cp systemd/.env.example systemd/.env
}

. "$PSScriptRoot/.env.example.ps1"

if (Test-Path .env.ps1 ) {
  . "$PSScriptRoot/.env.ps1"
}

$k8s_current_context = kubectl config current-context

write-host "==> Kubernetes context is [ $k8s_current_context ]" -ForegroundColor Blue

Function print_info($message) {
  write-host "==> $message"
}

Function print_help_info() {
  echo "
Usage: lnmp-k8s.ps1 COMMAND

Commands:
  kubectl-install    Install kubectl
  kubectl-info       Get kubectl latest version info

  wsl2               import wsl-k8s utils ps module

  wsl                [check|write-hosts|proxy]

  dist-containerd-arm64
"
}

if (!(Test-Path systemd/.env)) {
  Copy-Item systemd/.env.example systemd/.env
}

if ($args.length -eq 0) {
  print_help_info
  exit
}

Function get_kubectl_version() {
  $url = "https://storage.googleapis.com/kubernetes-release/release/stable.txt"
  $url = "https://mirror.azure.cn/kubernetes/kubectl/stable.txt"
  return $KUBECTL_VERSION = $(curl.exe -fsSL $url)
}

$command, $others = $args

switch ($args[0]) {
  "kubectl-install" {
    $KUBECTL_VERSION = get_kubectl_version
    write-host $KUBECTL_VERSION
    $url = "${KUBECTL_URL}/${KUBECTL_VERSION}/bin/windows/amd64/kubectl.exe"
    if (Test-Path C:\bin\kubectl.exe) {
      print_info "kubectl already install"
      return
    }
    curl.exe -fsSL $url -o C:\bin\kubectl.exe
  }

  "kubectl-info" {
    $KUBECTL_VERSION = get_kubectl_version
    "==> Latest Stable Version is: $KUBECTL_VERSION
    "
  }

  "dist-containerd-arm64" {
    if (Test-Path containerd-nightly-linux-arm64) {
      rm -r -force containerd-nightly-linux-arm64
    }

    Expand-Archive -Path linux_arm64.zip -DestinationPath containerd-nightly-linux-arm64
    mkdir containerd-nightly-linux-arm64/bin | out-null
    mv containerd-nightly-linux-arm64/containerd* containerd-nightly-linux-arm64/bin/
    mv containerd-nightly-linux-arm64/ctr containerd-nightly-linux-arm64/bin/

    cd containerd-nightly-linux-arm64
    tar -zcvf ../containerd-nightly-linux-arm64.tar.gz bin
    cd ..
    rm -r -force containerd-nightly-linux-arm64

    $sha256_hash = (Get-FileHash .\containerd-nightly-linux-arm64.tar.gz -Algorithm sha256).Hash.ToLower()

    echo "$sha256_hash containerd-nightly-linux-arm64.tar.gz" > containerd-nightly-linux-arm64.tar.gz.sha256sum
  }

  wsl2 {
    Import-Module $PSScriptRoot/wsl2/bin/WSL-K8S.psm1 -Force

    Get-Command -Module WSL-K8S
  }

  wsl {
    if($others -eq 'check'){
      & $PSScriptRoot/wsl2/bin/kube-check.ps1

      exit
    }

    if($others -eq 'write-hosts'){
      & $PSScriptRoot/wsl2/bin/wsl2host.ps1 --write

      exit
    }

    if($others -eq 'proxy'){
      & $PSScriptRoot/wsl2/kube-wsl2windows.ps1 k8s

      exit
    }

  }

  Default {
    Write-Warning "Command not found"
  }

}
