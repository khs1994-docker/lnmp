Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-module exportPath

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

  $url="https://www.7-zip.org/a/7z${VERSION}-x64.msi"
  $filename="7z${VERSION}-x64.msi"
  $unzipDesc="7zip"

  _exportPath $env:programFiles\7-Zip

  if($(_command $env:programFiles\7-Zip\7z.exe)){
    $VERSION_X=(& $env:programFiles\7-Zip\7z.exe).split(" ")[2].split(".")[0]
    $VERSION_Y=(& $env:programFiles\7-Zip\7z.exe).split(" ")[2].split(".")[1]
    $CURRENT_VERSION=$VERSION_X + $VERSION_Y

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
  # _cleanup ""
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  # Copy-item -r -force "" ""
  Start-Process -FilePath $filename -wait
  # _cleanup ""

  _exportPath $env:programFiles\7-Zip

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  (7z.exe).split(" ")[2]
}

Function uninstall(){
  & $env:programFiles\7-Zip\Uninstall.exe
}

Function getInfo(){

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
