$ErrorActionPreference = 'Stop'

foreach($item in ls */*/*/*/*/*/kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}

foreach($item in ls */*/*/*/*/kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}

foreach($item in ls */*/*/*/kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}

foreach($item in ls */*/*/kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}

foreach($item in ls */*/kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}

foreach($item in ls */kustomization.yaml){
    Write-Host "Validating $item"
    kubectl kustomize (Split-Path $item -Parent) | kubectl apply --dry-run=client -f -
}
