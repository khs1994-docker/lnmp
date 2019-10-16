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

$source=PWD
cd $HOME

wsl -- mkdir -p ~/.kube
wsl -- cp .kube/config ~/.kube/config

cd $source

wsl -- ${K8S_ROOT}/bin/kubectl config get-contexts
