Function Invoke-WSLK8S() {
  wsl -d wsl-k8s -u root -- $args
}

Function Invoke-Crictl() {
  wsl -d wsl-k8s -u root -- crictl $args
}

Function Invoke-CrictlCrio() {
  wsl -d wsl-k8s -u root -- crictl --config /wsl/wsl-k8s-data/k8s/etc/crictl.yaml $args
}

Function Invoke-Kubectl() {
  C:\bin\kubectl --kubeconfig $PSScriptRoot\..\certs\kubectl.kubeconfig $args
}

Function Get-WSL2IP() {
  $ip = Invoke-WSLK8S bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

  return $ip
}

Function Invoke-Supervisord() {
  if ($args.Length -ne 0) {
    Write-Warning "==> EXEC: supervisord $args"
    Invoke-WSLK8S supervisord $args

    return
  }

  Write-Warning "==> EXEC: supervisord -c /etc/supervisord.conf -u root"
  Invoke-WSLK8S supervisord -c /etc/supervisord.conf -u root
}

Function Invoke-Supervisorctl() {
  Invoke-WSLK8S supervisorctl $args
}
