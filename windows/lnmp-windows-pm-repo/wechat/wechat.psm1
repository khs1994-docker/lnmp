Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VERSION=$preVersion
    $url="https://dldir1.qq.com/weixin/Windows/WeChat${VERSION}.exe"
    $filename="WeChat${VERSION}.exe"
  }else{
    $url="https://dldir1.qq.com/weixin/Windows/WeChat_C${VERSION}.exe"
    $filename="WeChat_C${VERSION}.exe"
  }

  $unzipDesc="WeChat"

  if($(_command ${env:ProgramFiles(x86)}\Tencent\WeChat\WeChat.exe)){
    echo "==> $name $VERSION already install"
    return
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

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & get-command ${env:ProgramFiles(x86)}\Tencent\WeChat\WeChat.exe
}

Function uninstall(){
  & ${env:ProgramFiles(x86)}\Tencent\WeChat\Uninstall.exe
}

Function getInfo(){

  echo "
Package: $name
Version: $stableVersion
PreVersion: $preVersion
LatestVersion: $latestVersion
HomePage: $homepage
Releases: $releases
Bugs: $bug
Description: $description
"
}

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
