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
  $url="https://github.com/khs1994-docker/minio-mirror/releases/download/nightly/minio-windows-amd64.zip"

  $filename="minio-windows-amd64.zip"
  $unzipDesc="minio"

  if($(_command minio)){
    # $CURRENT_VERSION=""

    # if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"

        minio --version
        mc --version
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

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  minio --version
  mc --version
}

Function uninstall(){
  _cleanup C:\bin\minio.exe C:\bin\mc.exe
}
