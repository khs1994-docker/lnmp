Import-Alias ./lnmp/windows/pwsh-alias.txt -Force

./lnmp/windows/lnmp-windows-pm.ps1 install kubernetes-node@1.18.0
./lnmp/windows/lnmp-windows-pm.ps1 push    kubernetes-node@1.18.0
