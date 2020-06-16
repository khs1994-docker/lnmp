& $PSScriptRoot/wsl-k8s kubectl get csr --sort-by='{.metadata.creationTimestamp}'

Write-Warning "
==> Approve csr by EXEC: $ ./wsl2/bin/wsl-k8s kubectl certificate approve CSR_NAME(csr-xxxxx)
"
