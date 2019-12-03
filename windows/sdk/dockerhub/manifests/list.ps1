function list($token,$image,$ref,$header,$registry="registry.hub.docker.com"){
  if(!$header){
    $header="application/vnd.docker.distribution.manifest.list.v2+json"

    Write-Warning "Get manifest list"
  }

  . $PSScriptRoot/../cache/cache.ps1

  $cache_file = getCachePath "manifest@${registry}@$($image.replace('/','@'))@$($ref.replace('sha256:','')).json"

$result = Invoke-WebRequest `
-Authentication OAuth `
-Token (ConvertTo-SecureString $token -Force -AsPlainText) `
-Headers @{"Accept" = "$header" } `
"https://$registry/v2/$image/manifests/$ref" `
-PassThru `
-OutFile $cache_file `
-UserAgent "Docker-Client/19.03.5 (Windows)"

return ConvertFrom-Json (Get-Content $cache_file -Raw)
}
