& $PSScriptRoot/kubectl get csr --sort-by='{.metadata.creationTimestamp}'

""
"==> Approve cert by exec: ./wsl2/bin/kubectl certificate approve XXX"
