# 检查 wsl2 /etc/hosts 的
# wsl2.k8s.khs1994.com
# windows.k8s.khs1994.com
# ip 是否正确

# wsl -d wsl-k8s -u root -- bash -c `
# "cat /etc/hosts | grep -q 'wsl2.k8s.khs1994.com' && ping -c 1 wsl2.k8s.khs1994.com -W 1" | out-null

# if(!$?){
  write-host "==> set WSL2 /etc/hosts wsl2.k8s.khs1994.com ..." -ForegroundColor Green
  $WSL2_IP=& $PSScriptRoot/wsl2host

  wsl -d wsl-k8s -u root -- echo $WSL2_IP wsl2 wsl2.k8s.khs1994.com `>`> /etc/hosts
# }

wsl -d wsl-k8s -u root -- bash -c `
"cat /etc/hosts | grep -q 'wsl2.k8s.khs1994.com' && ping -c 1 windows.k8s.khs1994.com -W 1" | out-null

# if(!$?){
  write-host "==> set WSL2 /etc/hosts windows.k8s.khs1994.com ..." -ForegroundColor Green

  $WINDOWS_IP=wsl -d wsl-k8s -u root cat /etc/resolv.conf `| grep nameserver `| cut -d ' ' -f 2

  wsl -d wsl-k8s -u root -- echo $WINDOWS_IP windows.k8s.khs1994.com `>`> /etc/hosts
# }
