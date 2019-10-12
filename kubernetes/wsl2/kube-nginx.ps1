mkdir -Force $HOME/.kube-wsl2/kube-nginx/logs | out-null

$wsl_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

echo $wsl_ip

(Get-Content $PSScriptRoot\conf\kube-nginx.conf.temp) -replace "127.0.0.1",$wsl_ip `
    | Set-Content $PSScriptRoot/conf/kube-nginx.conf

nginx -c $PSScriptRoot/conf/kube-nginx.conf -p $HOME/.kube-wsl2/kube-nginx -s stop

RunHiddenConsole.exe nginx -c $PSScriptRoot/conf/kube-nginx.conf -p $HOME/.kube-wsl2/kube-nginx
