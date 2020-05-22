Import-Module wget

Function _checkHash($path, $HashType = $null, $Hash = $null) {
  if (!$Hash) {
    return $true
  }

  if ($HashType -eq 'sha256') {
    Import-Module $PSScriptRoot/../../sdk/dockerhub/utils/sha256.psm1

    if ($(sha256 $path) -eq $Hash) {
      return $true
    }

    return $false
  }

  if ($HashType -eq 'sha512') {
    Import-Module $PSScriptRoot/../../sdk/dockerhub/utils/sha512.psm1

    if ($(sha512 $path) -eq $Hash) {
      return $true
    }

    return $false

  }

  return $false
}

Function _downloader([string]$url, [string]$path, $soft, $version = 'null version', $HashType = $null, $Hash = $null) {
  if (!(Test-Path $path)) {
    Write-Host "==> Downloading $soft $version ...`n" -NoNewLine -ForegroundColor Green
    _wget $url $path
  }
  else {
    Write-Host "==> Skip download $soft $version, file already exists`n" -NoNewLine -ForegroundColor Yellow
  }

  if (!($(_checkHash $path $HashType $hash))) {
    Write-Host "==> [ $path ] [ $HashType ] check failed" -ForegroundColor Red
  }
}
