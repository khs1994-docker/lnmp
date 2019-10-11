$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

wsl -u root -- cp $K8S_WSL2_ROOT/conf/cni/10-flannel.conflist /opt/k8s/cni/net.d

wsl -u root -- cat /opt/k8s/cni/net.d/10-flannel.conflist

wsl -u root -- /usr/bin/containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/config.toml
