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
$url=$lwpm.url
Function getVersion($url){
  $result = Invoke-WebRequest -Method Head `
  -uri $url

  return $result.Headers.'Content-Disposition'.split('-')[2]
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=getVersion $url
  }
  if($isPre){
    $VERSION=getVersion $url
  }

  $filename="Postman-win64-${VERSION}-Setup.exe"
  $unzipDesc="postman"

  if($(_command "$env:APPDATA\..\Local\Postman\app-${VERSION}\Postman.exe")){
    "==> $name $VERSION already install"
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

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & Get-Command $env:APPDATA\..\Local\Postman\app-${VERSION}\Postman.exe
}

Function uninstall(){
  "Not Support"
}

Function getInfo(){
  $latestVersion=getVersion $url

  ConvertFrom-Json -InputObject @"
{
"Package": "$name",
"Version": "$stableVersion",
"PreVersion": "$preVersion",
"LatestVersion": "$latestVersion",
"LatestPreVersion": "$latestPreVersion",
"HomePage": "$homepage",
"Releases": "$releases",
"Bugs": "$bug",
"Description": "$description"
}
"@
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
