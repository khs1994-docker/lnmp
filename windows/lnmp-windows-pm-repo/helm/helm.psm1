Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'
$insert_path=$lwpm.path

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  if($isPre){
    $VERSION=$pre_version
  }

  # stable 与 pre url 相同，默认
  $download_url=$url_mirror.replace('${VERSION}',${VERSION});
  if((_getHttpCode $download_url)[0] -eq 4){
    $download_url=$url.replace('${VERSION}',${VERSION});
  }

  if($download_url){
    $url=$download_url
  }

  $filename="helm-v${VERSION}-windows-amd64.zip"
  $unzipDesc="helm"

  if($(_command helm)){
    $CURRENT_VERSION=(ConvertFrom-Json -InputObject (helm version).trim('version.BuildInfo')).Version.trim("v")

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
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
  _cleanup helm
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force helm\windows-amd64\helm.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup helm

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  (ConvertFrom-Json -InputObject (helm version).trim('version.BuildInfo')).Version.trim("v")
}

Function uninstall(){
  _cleanup C:\bin\helm.exe
}
