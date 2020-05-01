Import-Module wget

Function _downloader($url, $path, $soft, $version = 'null version',$wsl = $true){
  if (!(Test-Path $path)){
    Write-Host "==> Downloading $soft $version ..." -NoNewLine -ForegroundColor Green
    _wget $url $path $wsl
    echo ""
  }else{
     Write-Host "==> Skip download $soft $version" -NoNewLine -ForegroundColor Yellow
     echo ""
  }
}
