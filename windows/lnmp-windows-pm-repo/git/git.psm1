Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

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
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'

Function install_after(){

}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  if($isPre){
    $VERSION=$pre_version
    # $url=$lwpm.'pre-url'
  }else{

  }

  $download_url=$url_mirror.replace('${VERSION}',${VERSION});
  if((_getHttpCode $download_url)[0] -eq 4){
    $download_url=$url.replace('${VERSION}',${VERSION});
  }

  if($download_url){
    $url=$download_url
  }

  $filename="Git-${VERSION}-64-bit.exe"
  $unzipDesc="git"

  if($(_command git)){
    $CURRENT_VERSION=(git --version).split(" ")[2].trim(".windows.1")

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
  # _cleanup ""
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  # Copy-item -r -force "" ""
  Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  # _exportPath "/path"

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  git --version
}

Function uninstall(){
  & $env:ProgramFiles\Git\unins000.exe
  # _cleanup ""
}
