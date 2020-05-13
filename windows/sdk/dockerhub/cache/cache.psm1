
function Get-CachePath($path = $null) {
  if (!$env:LNMP_CACHE) {
    $LNMP_CACHE = "$home/.khs1994-docker-lnmp"
  }

  $cache_dir = "${LNMP_CACHE}/dockerhub"

  New-Item -Type Directory -Force $cache_dir > $null 2>&1

  return "$cache_dir/$path"
}

Export-ModuleMember -Function Get-CachePath
