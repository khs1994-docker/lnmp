Import-Module downloader
Import-Module unzip

Function install($VERSION="0.27.0"){
  $url="https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_windows_amd64.zip"
  $name="Frp"
  $filename="frp_${VERSION}_windows_amd64.zip"
  $unzipDesc="frp"
  $command="frpc"

  if($(_command $command)){
    $CURRENT_VERSION=(& $command --version)

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
  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item frp\frp_${VERSION}_windows_amd64\frpc.exe C:\bin\

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & $command --version
}

Function uninstall(){
  Remove-item C:\bin\frpc.exe
}
