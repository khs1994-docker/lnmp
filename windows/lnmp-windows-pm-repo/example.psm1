Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$ErrorActionPreference='stop'

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
# $homepage=$lwpm.homepage
$releases=$lwpm.releases
# $bug=$lwpm.bug
$name=$lwpm.name
# $description=$lwpm.description
$url=$lwpm.url
$preUrl=$lwpm.preUrl

Function install_after(){

}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  # $url=$url.replace('${VERSION}',${VERSION});

  if($isPre){
    $VERSION=$preVersion
    # $url=$preUrl.replace('${VERSION}',${VERSION});
  }else{

  }

  $url=$url.replace('${VERSION}',${VERSION});

  $filename=""
  $unzipDesc="example"

  # _exportPath "/path"

  if($(_command example)){
    $ErrorActionPreference='Continue'
    $CURRENT_VERSION=""

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
        return
    }
    $ErrorActionPreference='stop'
  }

  # 下载原始 zip 文件，若存在则不再进行下载

  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _cleanup "$unzipDesc"
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force "$unzipDesc/" ""
  # Start-Process -FilePath $filename -wait
  # _cleanup "$unzipDesc"

  # [environment]::SetEnvironmentvariable("", "", "User")
  # _exportPath "/path"

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  if($lwpm.scripts.test){
    powershell -c $lwpm.scripts.test
  }
}

Function uninstall($prune=0){
  "Not Support"
  # _cleanup ""
  # user data
  if($prune){
    # _cleanup ""
  }
}

# 自定义获取最新版本号的方法

function getLatestVersion(){
  $stableVersion = $null
  $preVersion = $null

  # TODO

  return $stableVersion,$preVersion
}
