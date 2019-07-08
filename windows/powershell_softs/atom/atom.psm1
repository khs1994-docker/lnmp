Import-Module downloader
Import-Module unzip

Function install($VERSION="1.38.2",$preVersion=0){
  if($preVersion){
    $VERSION="1.39.0-beta3"
  }
  $url="https://github.com/atom/atom/releases/download/v${VERSION}/AtomSetup.exe"
  $name="Atom"
  $filename="AtomSetup-${VERSION}.exe"
  $unzipDesc="atom"

  if($(_command atom)){
    $CURRENT_VERSION=(atom --version).split(":")[2].trim()

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
  atom --version
}

Function uninstall(){
  echo ""
  # Remove-item
}
