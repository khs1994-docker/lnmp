<#
.SYNOPSIS
  Sync windows ~/.kube/config to WSL2 ~/.kube/config
.DESCRIPTION
  Sync windows ~/.kube/config to WSL2 ~/.kube/config

.INPUTS

.OUTPUTS

.NOTES

#>

. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

$WINDOWS_HOME_ON_WSL=wsl -d wsl-k8s -- wslpath "'$HOME'"

wsl -d wsl-k8s -- mkdir -p ~/.kube
wsl -d wsl-k8s -- cp $WINDOWS_HOME_ON_WSL/.kube/config ~/.kube/config

wsl -d wsl-k8s -- ${K8S_ROOT}/bin/wsl-k8s kubectl config get-contexts
