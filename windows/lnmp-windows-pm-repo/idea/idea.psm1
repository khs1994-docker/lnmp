Import-Module downloader
Import-Module unzip

Function install($VERSION="1.15.5387",$preVersion=0){
  if($preVersion){

  }
  $url="https://download.jetbrains.com/toolbox/jetbrains-toolbox-${VERSION}.exe"
  $name="Jetbrains Toolbox"
  $filename="jetbrains-toolbox-${VERSION}.exe"
  $unzipDesc="jetbrains-toolbox"

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
  echo ""
}

Function uninstall(){
  echo ""
  # Remove-item
}
