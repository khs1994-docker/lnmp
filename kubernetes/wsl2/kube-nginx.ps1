exit
. $PSScriptRoot/.env.example.ps1
. $PSScriptRoot/.env.ps1
& $PSScriptRoot/bin/wsl2d.ps1 wsl-k8s

Import-Module $PSScriptRoot/bin/WSL-K8S.psm1

mkdir -Force $HOME/.khs1994-docker-lnmp/wsl-k8s/kube-nginx/logs | out-null

$wsl_ip = Get-WSL2IP

Write-Output $wsl_ip > $PSScriptRoot/conf/.kube_nginx_wsl2_ip

(Get-Content $PSScriptRoot\conf\kube-nginx.conf.temp) `
  -replace "##WSL2_HOST##", $wsl_ip `
  -replace "##WINDOWS_HOST##", $WINDOWS_HOST `
| Set-Content $PSScriptRoot/conf/kube-nginx.conf

if (Test-Path $HOME/.khs1994-docker-lnmp/wsl-k8s/kube-nginx/logs/nginx.pid) {
  nginx -c $PSScriptRoot/conf/kube-nginx.conf `
    -p $HOME/.khs1994-docker-lnmp/wsl-k8s/kube-nginx -s stop
}

sleep 5

if ($args[0] -eq 'stop') {
  exit
}

Start-Process -FilePath nginx `
  -WorkingDirectory $HOME/.khs1994-docker-lnmp/wsl-k8s/kube-nginx `
  -WindowStyle Hidden `
  -ArgumentList (Write-Output `
    -c $PSScriptRoot/conf/kube-nginx.conf).split(' ')

Start-Sleep 1

Get-Process nginx
