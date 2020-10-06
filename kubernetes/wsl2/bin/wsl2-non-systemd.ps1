if($args[0] -eq 'delete'){
  Remove-Item \\wsl$\wsl-k8s\non-systemd

  exit
}

New-Item \\wsl$\wsl-k8s\non-systemd
