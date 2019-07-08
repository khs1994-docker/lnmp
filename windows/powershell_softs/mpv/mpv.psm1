Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="20181002",$preVersion=0){
  if($preVersion){

  }
  $url="https://mpv.srsfckn.biz/mpv-x86_64-${VERSION}.7z"
  $name="mpv"
  $filename="mpv-x86_64-${VERSION}.7z"
  $unzipDesc="mpv"

  if($(_command mpv)){
    $CURRENT_VERSION=""

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
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force "" ""
  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  example version
}

Function uninstall(){
  _cleanup ""
}
