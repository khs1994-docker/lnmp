Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="3.0.0-alpha.1",$preVersion=0){
  if($preVersion){
    $VERSION="3.0.0-alpha.1"
  }
  $url="https://mirrors.huaweicloud.com/helm/v${VERSION}/helm-v${VERSION}-windows-amd64.zip"
  $name="Helm"
  $filename="helm-v${VERSION}-windows-amd64.zip"
  $unzipDesc="helm"

  if($(_command helm)){
    $CURRENT_VERSION=(helm version).split(",")[0].split("v")[2].trim('"')

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
  _cleanup helm
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force helm\windows-amd64\helm.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup helm

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  helm version
}

Function uninstall(){
  _cleanup C:\bin\helm.exe
}
