Function Get-Registry($registry=$null) {
  if (!($registry)) {
    if ($env:REGISTRY_MIRROR) {
      $registry = $env:REGISTRY_MIRROR
      Write-host "==> Read `$registry from `$env:REGISTRY_MIRROR($env:REGISTRY_MIRROR)" -ForegroundColor Blue
    }
    else {
      if ($env:LNMP_CN_ENV -ne "false") {
        $registry = "hub-mirror.c.163.com"
      }
      else {
        $registry = "registry.hub.docker.com"
        # $registry = "registry-1.docker.io"
      }
    }
  }

  return $registry
}

Export-ModuleMember -Function Get-Registry
