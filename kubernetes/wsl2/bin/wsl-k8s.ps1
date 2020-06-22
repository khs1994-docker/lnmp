$command, $arg = $args

switch ($command) {
  kubectl {
    C:\bin\kubectl --kubeconfig $PSScriptRoot\..\certs\kubectl.kubeconfig $arg
  }
  crictl {
    wsl -d wsl-k8s -u root -- crictl $arg
  }
  Default {
    Write-Host "

kubectl
crictl
"
  }
}
