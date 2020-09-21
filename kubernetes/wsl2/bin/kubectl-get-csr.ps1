import-module $PSScriptRoot/WSL-K8S.psm1

invoke-kubectl get csr --sort-by='{.metadata.creationTimestamp}'

Write-Warning "
==> Approve csr by EXEC:
$ Import-Module ./wsl2/bin/WSL-K8S.psm1
$ invoke-kubectl certificate approve <CSR_NAME(csr-xxxxx)>
"
