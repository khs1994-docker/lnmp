Import-Module downloader
Import-Module unzip
Import-Module command

Function install($VERSION="1.16.0",$preVersion=0){
  if($preVersion){
    $VERSION="1.17.2"
  }
  $url="https://github.com/yarnpkg/yarn/releases/download/v${VERSION}/yarn-${VERSION}.msi"
  $name="Yarn"
  $filename="yarn-${VERSION}.msi"
  $unzipDesc="yarn"

  if($(_command yarn)){
    $CURRENT_VERSION=$(yarn --version)

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
  # Copy-item deno/deno.exe C:\bin

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  yarn --version
}

Function uninstall(){
  echo ""
  # Remove-item
}
