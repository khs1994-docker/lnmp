Import-Module downloader
Import-Module unzip

Function install($VERSION="0.6.1"){
  $url="https://dl.bintray.com/zealdocs/windows/zeal-${VERSION}-windows-x64.msi"
  $name="Zeal"
  $filename="zeal-${VERSION}-windows-x64.msi"
  # $unzipDesc="zeal"

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

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  ls 'C:\Program Files\Zeal\zeal.exe'
}

Function uninstall(){
  echo ""
  # Remove-item
}
