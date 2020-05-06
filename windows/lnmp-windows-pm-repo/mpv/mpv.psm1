Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module ln

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

Function _install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  $download_url=$url.replace('${VERSION}',${VERSION});
  $filename="mpv-${VERSION}-x86_64.7z"

  if($isPre){
    $VERSION=$pre_version
    $download_url=$pre_url.replace('${VERSION}',${VERSION});
    $filename="mpv-x86_64-${VERSION}.7z"
  }

  if($download_url){
    $url=$download_url
  }

  _exportPath $insert_path

  if($(_command mpv)){
    $CURRENT_VERSION=""
    # if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
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

  mkdir -f ${env:ProgramData}/mpv | out-null

  powershell -c "7z x $filename -aoa -r -o${env:ProgramData}/mpv"

  _ln ${env:ProgramData}\mpv\mpv.exe $HOME\Desktop\mpv.exe

  # 安装 Fix me
  # Copy-item -r -force "" ""
  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  mpv version
}

Function _uninstall(){
  _cleanup ""
}
