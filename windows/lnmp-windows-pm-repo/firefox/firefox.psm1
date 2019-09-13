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
$preUrl=$lwpm.preUrl

Function getVersion($url){
  try{
    Invoke-WebRequest `
      -MaximumRedirection 0 `
      -Method Head `
      -uri $url
    }catch{
      $version=$_.Exception.Response.Headers.Location.LocalPath.split('/')[4]
    }

    return $version
}

Function install($VERSION=0,$isPre=0){

  if(!($VERSION)){
    $VERSION=getVersion $url
  }

  if($isPre){
    $VERSION=getVersion $preUrl
  }

  $url="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION}/win64/en-US/Firefox%20Setup%20${VERSION}.exe"

  $filename="Firefox Setup ${VERSION}.exe"
  $unzipDesc="firefox"

  if($(_command "$env:ProgramFiles\Mozilla Firefox\firefox.exe")){
    # $CURRENT_VERSION=""

    # if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    # }
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
  & get-command "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
}

Function uninstall(){
  & "$env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe"
}

Function getInfo(){
  $latestVersion=getVersion $url
  $latestPreVersion=getVersion $preUrl

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
