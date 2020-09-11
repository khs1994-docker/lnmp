<#
.SYNOPSIS
  Add wsl-k8s config to ~/.kube/config
.DESCRIPTION
  Add wsl-k8s config to ~/.kube/config
.EXAMPLE


.INPUTS

.OUTPUTS

.NOTES

#>

. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

$kubeconfig = "$HOME/.kube/config"

# $kubeconfig="$PSScriptRoot/kubectl.kubeconfig"

import-module $PSScriptRoot/WSL-K8S.psm1

invoke-kubectl config set-cluster wsl2 `
  --certificate-authority=$PSScriptRoot/../certs/ca.pem `
  --embed-certs=true `
  --server=${KUBE_APISERVER} `
  --kubeconfig=$kubeconfig

invoke-kubectl config set-credentials wsl2-admin `
  --client-certificate=$PSScriptRoot/../certs/admin.pem `
  --client-key=$PSScriptRoot/../certs/admin-key.pem `
  --embed-certs=true `
  --kubeconfig=$kubeconfig

invoke-kubectl config set-context wsl2 `
  --cluster=wsl2 `
  --user=wsl2-admin `
  --kubeconfig=$kubeconfig

Write-Warning "==> Exec:

$ kubectl config get-contexts
$ kubectl config use-context wsl2

switch to wsl2

==> Exec:

$ ./wsl2/bin/kubectl-config-sync

to sync ~/.kube/config to WSL
"
