Import-Module downloader
Import-Module unzip
Import-Module cleanup

Function install($VERSION="0.7.2",$preVersion=0){
  if($preVersion){

  }
  $url="https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_windows_amd64.zip"
  $name="Dive"
  $filename="dive_${VERSION}_windows_amd64.zip"
  $unzipDesc="dive"

  if($(_command dive)){
    $CURRENT_VERSION=(dive --version).split(" ")[1]

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
  _cleanup dive
  # 解压 zip 文件 Fix me
  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item dive\dive.exe C:\bin\
  _cleanup dive
  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  dive --version
}

Function uninstall(){
  _cleanup C:\bin\dive.exe
}
