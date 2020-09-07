Function Invoke-WSL() {
  wsl -d wsl-k8s -u root -- $args
}

Function Invoke-crictl() {
  wsl -d wsl-k8s -u root -- crictl $args
}

Function Invoke-crictlCrio() {
  wsl -d wsl-k8s -u root -- crictl --config /wsl/wsl-k8s-data/k8s/etc/crictl.yaml $args
}

Function Invoke-kubectl() {
  C:\bin\kubectl --kubeconfig $PSScriptRoot\..\certs\kubectl.kubeconfig $args
}

Function Get-WSL2IP() {
  $ip = Invoke-WSL bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

  return $ip
}

Function Invoke-Supervisord() {
  if ($args.Length -ne 0) {
    Write-Warning "==> EXEC: supervisord $args"
    Invoke-WSL supervisord $args

    return
  }

  Write-Warning "==> EXEC: supervisord -c /etc/supervisord.conf -u root"
  Invoke-WSL supervisord -c /etc/supervisord.conf -u root
}

Function Invoke-Supervisorctl() {
  Invoke-WSL supervisorctl $args
}
