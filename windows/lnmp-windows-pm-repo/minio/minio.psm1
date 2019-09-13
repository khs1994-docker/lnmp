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
  }
  $url="https://github.com/khs1994-docker/minio-mirror/releases/download/nightly/minio-windows-amd64.zip"

  $filename="minio-windows-amd64.zip"
  $unzipDesc="minio"

  if($(_command minio)){
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
  # _cleanup minio.exe mc.exe
  _unzip $filename C:\bin

  # 安装 Fix me
  # Start-Process -FilePath $filename -wait
  # _cleanup minio.exe mc.exe

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  minio version
  mc version
}

Function uninstall(){
  _cleanup C:\bin\minio.exe C:\bin\mc.exe
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
