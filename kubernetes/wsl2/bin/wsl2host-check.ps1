wsl -u root -- bash -c `
"cat /etc/hosts | grep -q 'wsl2.lnmp.khs1994.com' && ping -c 1 wsl2.lnmp.khs1994.com -W 1" | out-null

if(!$?){
  "==> set WSL2 /etc/hosts wsl2.lnmp.khs1994.com ..."
  $WSL2_IP=& $PSScriptRoot/wsl2host

  wsl -u root -- echo $WSL2_IP wsl2.lnmp.khs1994.com `>`> /etc/hosts
}

wsl -u root -- bash -c `
"cat /etc/hosts | grep -q 'wsl2.lnmp.khs1994.com' && ping -c 1 windows.lnmp.khs1994.com -W 1" | out-null

if(!$?){
  "==> set WSL2 /etc/hosts windows.lnmp.khs1994.com ..."

  $WINDOWS_IP=wsl -u root cat /etc/resolv.conf `| grep nameserver `| cut -d ' ' -f 2

  wsl -u root -- echo $WINDOWS_IP windows.lnmp.khs1994.com `>`> /etc/hosts
}
