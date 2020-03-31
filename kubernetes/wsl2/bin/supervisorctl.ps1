Function printInfo(){
  "
==> $args
"
}

Function _cp_conf(){
  printInfo "Copy WSL2 supervisor conf file to WSL2 /etc/supervisor.d/ ..."
  # 复制配置文件
  $K8S_WSL2_ROOT=powershell -c "cd $PSScriptRoot/../ ; wsl pwd"
  wsl -u root -- cp ${K8S_WSL2_ROOT}/supervisor.d/*.ini /etc/supervisor.d/
}

Function _generate_conf(){
  printInfo "generate supervisor conf ..."

  printInfo "handle kube-apiserver supervisor conf ..."
  & $PSScriptRoot/../kube-apiserver.ps1
  printInfo "handle kube-controller-manager supervisor conf ..."
  & $PSScriptRoot/../kube-controller-manager.ps1
  printInfo "handle kube-scheduler supervisor conf ..."
  & $PSScriptRoot/../kube-scheduler.ps1

  printInfo "handle kube-proxy supervisor conf ..."
  & $PSScriptRoot/../kube-proxy.ps1
  printInfo "handle kubelet supervisor conf ..."
  & $PSScriptRoot/../kubelet.ps1
  printInfo "handle kube-containerd supervisor conf ..."
  & $PSScriptRoot/../kube-containerd.ps1
}

if ($args[0] -eq 'cp'){
  _cp_conf

  exit
}

if ($args[0] -eq 'g' -or $args[0] -eq 'generate'){
  _generate_conf

  exit
}

if ($args[0] -eq 'update'){
  _cp_conf
}

wsl -u root -- bash -ec "supervisorctl $args"
