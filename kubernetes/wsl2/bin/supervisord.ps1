if ($args.Length -ne 0){
  Write-Warning "==> EXEC: supervisord $args"
  wsl -u root -- supervisord $args

  exit
}

Write-Warning "==> EXEC: supervisord -c /etc/supervisord.conf -u root"
wsl -u root -- supervisord -c /etc/supervisord.conf -u root
