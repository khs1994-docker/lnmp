$K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot ; wsl pwd"

wsl -u root -- /usr/bin/containerd `
--config ${K8S_WSL2_ROOT}/conf/kube-containerd/config.toml
