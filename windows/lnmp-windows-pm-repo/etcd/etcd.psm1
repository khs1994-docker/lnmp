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

  $url="https://mirrors.huaweicloud.com/etcd/v${VERSION}/etcd-v${VERSION}-windows-amd64.zip"

  $filename="etcd-v${VERSION}-windows-amd64.zip"
  $unzipDesc="etcd"

  if($(_command etcd)){
    $CURRENT_VERSION=(etcd --version).split(" ")[2]

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

  # 解压 zip 文件 Fix me
  _cleanup etcd
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force etcd\etcd-v${VERSION}-windows-amd64\etcd.exe C:\bin\
  Copy-item -r -force etcd\etcd-v${VERSION}-windows-amd64\etcdctl.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup etcd

  # [environment]::SetEnvironmentvariable("", "", "User")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  etcd --version
}

Function uninstall(){
  _cleanup C:\bin\etcd.exe C:\bin\etcdctl.exe
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
