& $PSScriptRoot/kubectl get csr --sort-by='{.metadata.creationTimestamp}'

Write-Warning "
==> Approve csr by EXEC: $ ./wsl2/bin/kubectl certificate approve CSR_NAME(XXX)
"
