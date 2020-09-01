$NODE_IP="192.168.199.100"

kube-proxy `
--v=6 `
--kubeconfig=$PSScriptRoot\..\wsl2\certs\kube-proxy.kubeconfig `
--feature-gates="WinOverlay=true,WinDSR=true" `
--network-name=vxlan0 `
--cluster-cidr=10.244.0.0/16 `
--hostname-override=windows `
--bind-address=$NODE_IP `
--proxy-mode=kernelspace `
--enable-dsr=true

# --windows-service `
