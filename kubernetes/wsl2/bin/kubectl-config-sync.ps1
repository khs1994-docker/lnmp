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

Import-Module $PSScriptRoot/WSL-K8S.psm1

$WINDOWS_HOME_ON_WSL = Invoke-WSL wslpath "'$HOME'"

Invoke-WSL mkdir -p ~/.kube
Invoke-WSL cp $WINDOWS_HOME_ON_WSL/.kube/config ~/.kube/config

Invoke-WSL ${K8S_ROOT}/bin/kubectl config get-contexts
