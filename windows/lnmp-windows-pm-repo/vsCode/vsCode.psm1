Import-Module downloader
Import-Module unzip

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$pre_url=$lwpm.'pre-url'

Function _getVersion($url){
  try{
    Invoke-WebRequest `
      -MaximumRedirection 0 `
      -Method Head `
      -uri $url
    }catch{
      $location = $_.Exception.Response.Headers.Location
      $url=$location.AbsoluteUri
      $version=$location.Segments[3].split('-')[2].trim('.exe')
    }

    return $version,$url
}

Function _getLatestVersion(){
  return $(_getVersion $url)[0],$(_getVersion $pre_url)[0]
}

Function _install($VERSION=0,$isPre=0){
  if(!$IsWindows){
    $url=$url.replace('win32-x64-user',$env:lwpm_os)
    $pre_url=$pre_url.replace('win32-x64-user',$env:lwpm_os)
  }

  if(!($VERSION)){
    $VERSION,$url=_getVersion $url
  }
  if($isPre){
    $VERSION,$url=_getVersion $pre_url
  }

  write-host "==> Download from $url" -ForegroundColor Blue

  $filename="VSCodeUserSetup-x64-${VERSION}.exe"
  $unzipDesc="vscode"

  if(!$IsWindows){
    $filename="VSCode-${env:lwpm_os}.zip"
  }

  if($(_command code)){
    $CURRENT_VERSION=(code --version)[0]

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
        return
    }
  }

  # 下载原始 zip 文件，若存在则不再进行下载

  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _unzip $filename $unzipDesc
  # 安装 Fix me
  # Copy-item "" ""
  if($IsWindows){
    Start-Process -FilePath $filename -wait
  }else{
    unzip $filename -d /Applications/

    "==> Checking ${name} ${VERSION} install ..."
    & "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" --version | Out-Host

    return
  }

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  code --version
}

Function _uninstall(){
  ""
  # Remove-item
}
