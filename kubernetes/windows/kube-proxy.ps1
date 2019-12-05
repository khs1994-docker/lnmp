$ip="192.168.199.100"

kube-proxy `
--v=6 `
--kubeconfig=$PSScriptRoot\..\wsl2\certs\kube-proxy.kubeconfig `
--feature-gates="WinOverlay=true" `
--network-name=vxlan0 `
--cluster-cidr=172.30.0.0/16 `
--hostname-override=windows `
--bind-address=$ip `
--proxy-mode=kernelspace

# --windows-service `
