Import-Module downloader
Import-Module unzip

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
  $url="https://github.com/zealdocs/zeal/releases/download/v${VERSION}/zeal-${VERSION}-windows-x64.msi"

  $filename="zeal-${VERSION}-windows-x64.msi"
  # $unzipDesc="zeal"

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

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  ls 'C:\Program Files\Zeal\zeal.exe'
}

Function uninstall(){
  echo ""
  # Remove-item
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
