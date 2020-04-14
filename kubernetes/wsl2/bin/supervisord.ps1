if ($args.Length -ne 0){
  Write-Warning "==> EXEC: supervisord $args"
  wsl -d wsl-k8s -u root -- supervisord $args

  exit
}

Write-Warning "==> EXEC: supervisord -c /etc/supervisord.conf -u root"
wsl -d wsl-k8s -u root -- supervisord -c /etc/supervisord.conf -u root
