mkdir -Force $HOME/.k8s-wsl2/kube-nginx/logs | out-null

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

Write-Output $wsl_ip > $PSScriptRoot/conf/.kube_nginx_wsl2_ip

(Get-Content $PSScriptRoot\conf\kube-nginx.conf.temp) -replace "127.0.0.1",$wsl_ip `
    | Set-Content $PSScriptRoot/conf/kube-nginx.conf

nginx -c $PSScriptRoot/conf/kube-nginx.conf -p $HOME/.k8s-wsl2/kube-nginx -s stop

sleep 5

if ($args[0] -eq 'stop'){
  exit
}

Start-Process -FilePath nginx `
  -WorkingDirectory $HOME/.k8s-wsl2/kube-nginx `
  -WindowStyle Hidden `
  -ArgumentList (Write-Output `
  -c $PSScriptRoot/conf/kube-nginx.conf).split(' ')

Start-Sleep 1

Get-Process nginx
