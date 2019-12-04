function list($token,$image,$ref,$header,$registry="registry.hub.docker.com"){
  $header_default="application/vnd.docker.distribution.manifest.list.v2+json"

  if(!$header){
    $header=$header_default

    Write-Warning "Get manifest list"
  }

  . $PSScriptRoot/../cache/cache.ps1

  $cache_file = getCachePath "manifest@${registry}@$($image.replace('/','@'))@$($ref.replace('sha256:','')).json"

  try{
    $result = Invoke-WebRequest `
      -Authentication OAuth `
      -Token (ConvertTo-SecureString $token -Force -AsPlainText) `
      -Headers @{"Accept" = "$header" } `
      "https://$registry/v2/$image/manifests/$ref" `
      -PassThru `
      -OutFile $cache_file `
      -UserAgent "Docker-Client/19.03.5 (Windows)"
  }catch{
    if($header -eq $header_default){
      $result = $_.Exception.Response
      # write-host $result.StatusCode
      # $code = (ConvertFrom-Json $content).errors[0].code
      # if($code -ne "MANIFEST_UNKNOWN"){

      #   return
      # }

      Write-Warning "Get manifest list error [ $($result.StatusCode) ], try get manifest ..."

      return ConvertFrom-Json -InputObject @"
{
  "schemaVersion": 1
}
"@
    }
  }

  return ConvertFrom-Json (Get-Content $cache_file -Raw)
}
