Import-Module wget

Function _downloader([string]$url, [string]$path, $soft, $version = 'null version', $HashType = $null, $Hash = $null) {
  if (!(Test-Path $path)) {
    Write-Host "==> Downloading $soft $version ...`n" -NoNewLine -ForegroundColor Green
    _wget $url $path
  }
  else {
    Write-Host "==> Skip download $soft $version, file [ $path ] already exists`n" -NoNewLine -ForegroundColor Yellow
  }

  if (!($(Test-Hash $path $HashType $hash))) {
    Write-Host "==> [ $path ] [ $HashType ] check failed" -ForegroundColor Red
  }
}
