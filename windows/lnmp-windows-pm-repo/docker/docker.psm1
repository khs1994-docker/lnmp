Import-Module downloader
Import-Module unzip

Function install($VERSION="19.03.0-rc2",$preVersion=0){
  if($preVersion){

  }
  $url="https://download.docker.com/win/edge/Docker%20Desktop%20Installer.exe"
  $name="Docker"
  $filename="docker.exe"
  $unzipDesc="docker"

  if($(_command docker)){
    $CURRENT_VERSION=(docker --version).split(" ")[2].trim(",")

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
  # _unzip $filename $unzipDesc
  # 安装 Fix me
  # Copy-item "" ""

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  docker --version
}

Function uninstall(){
  echo ""
  # Remove-item
}
