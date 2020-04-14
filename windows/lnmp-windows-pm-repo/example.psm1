Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath
Import-Module getHttpCode

$ErrorActionPreference='stop'

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
# $homepage=$lwpm.homepage
$releases=$lwpm.releases
# $bug=$lwpm.bug
$name=$lwpm.name
# $description=$lwpm.description
$url=$lwpm.url
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'
$insert_path=$lwpm.path

Function install_after(){

}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  # stable 与 pre url 不同
  # 先定义 stable url
  # $download_url=$url_mirror.replace('${VERSION}',${VERSION});
  # if((_getHttpCode $download_url)[0] -eq 4){
    # $download_url=$url.replace('${VERSION}',${VERSION});
  # }

  if($isPre){
    $VERSION=$pre_version

    # 后定义 pre url
    # $download_url=$pre_url_mirror.replace('${VERSION}',${VERSION});
    # if((_getHttpCode $download_url)[0] -eq 4){
      # $download_url=$pre_url.replace('${VERSION}',${VERSION});
    # }
  }else{

  }

  # stable 与 pre url 相同，默认
  # $download_url=$url_mirror.replace('${VERSION}',${VERSION});
  # if((_getHttpCode $download_url)[0] -eq 4){
  $download_url=$url.replace('${VERSION}',${VERSION});
  # }

  if($download_url){
    $url=$download_url
  }

  # Write-Host "Please download on this website:

# ${releases}

# " -ForegroundColor Green
#  exit

  # fix me
  $filename=""
  $unzipDesc="example"

  # _exportPath $lwpm.path

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
  # _exportPath $lwpm.path

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
  $stable_version = $null
  $pre_version = $null

  # TODO

  return $stable_version,$pre_version
}
