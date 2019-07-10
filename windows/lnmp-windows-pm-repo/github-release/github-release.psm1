Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="0.7.2",$preVersion=0){
  if($preVersion){

  }
  $url="https://github.com/aktau/github-release/releases/download/v${VERSION}/windows-amd64-github-release.zip"
  $name="github-release"
  $filename="windows-amd64-github-release-v${VERSION}.zip"
  $unzipDesc="github-release"

  if($(_command github-release)){
    $CURRENT_VERSION=(github-release --version).split(" ")[1].trim('v')

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
  _cleanup github-release

  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force github-release\bin\windows\amd64\github-release.exe C:\bin
  # Start-Process -FilePath $filename -wait
  _cleanup github-release

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  github-release --version
}

Function uninstall(){
  _cleanup C:\bin\github-release.exe
}
