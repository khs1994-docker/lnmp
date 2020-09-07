import-module $PSScriptRoot/wsl-k8s.psm1

invoke-kubectl get csr --sort-by='{.metadata.creationTimestamp}'

Write-Warning "
==> Approve csr by EXEC:
$ import-module ./wsl2/bin/wsl-k8s.psm1
$ invoke-kubectl certificate approve CSR_NAME(csr-xxxxx)
"
