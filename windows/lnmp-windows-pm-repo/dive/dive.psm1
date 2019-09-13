Import-Module downloader
Import-Module unzip
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
  }

  $url="https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_windows_amd64.zip"

  $filename="dive_${VERSION}_windows_amd64.zip"
  $unzipDesc="dive"

  if($(_command dive)){
    $CURRENT_VERSION=(dive --version).split(" ")[1]

    if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
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
  _cleanup dive
  # 解压 zip 文件 Fix me
  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item dive\dive.exe C:\bin\
  _cleanup dive
  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  dive --version
}

Function uninstall(){
  _cleanup C:\bin\dive.exe
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\releases.ps1

  $latestVersion=getLatestRelease $githubRepo

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
