Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="latest"){
  $url="https://dl.min.io/server/minio/release/windows-amd64/minio.exe"
  $name="minio server"
  $filename="minio.exe"
  $unzipDesc="minio server"

  if($(_command minio)){
    # $CURRENT_VERSION=""

    # if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    # }
  }

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  _downloader `
    "https://dl.min.io/client/mc/release/windows-amd64/mc.exe" `
    "mc.exe" `
    "minio client" `
    latest
  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _cleanup minio.exe mc.exe
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force minio.exe mc.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup minio.exe mc.exe

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  minio version
}

Function uninstall(){
  _cleanup C:\bin\minio.exe C:\bin\mc.exe
}
