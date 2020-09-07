Function invoke-crictl() {
  wsl -d wsl-k8s -u root -- crictl $args
}

Function invoke-crictlCrio() {
  wsl -d wsl-k8s -u root -- crictl --config /wsl/wsl-k8s-data/k8s/etc/crictl.yaml $args
}

Function invoke-kubectl() {
  C:\bin\kubectl --kubeconfig $PSScriptRoot\..\certs\kubectl.kubeconfig $args
}
