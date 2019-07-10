Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="1.5.2",$preVersion=0){
  if($preVersion){

  }
  $url="https://github.com/coredns/coredns/releases/download/v${VERSION}/coredns_${VERSION}_windows_amd64.tgz"
  $name="CoreDNS"
  $filename="coredns_${VERSION}_windows_amd64.tgz"
  $unzipDesc="CoreDNS"

  if($(_command coredns)){
    $CURRENT_VERSION=(coredns --version).split("CoreDNS-")[1]

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
  _cleanup coredns.exe
  wsl -- tar -zxf coredns_1.5.2_windows_amd64.tgz

  # 安装 Fix me
  Copy-item -r -force coredns.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup coredns.exe

  # [environment]::SetEnvironmentvariable("", "", "User")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  coredns --version
}

Function uninstall(){
  _cleanup C:\bin\coredns.exe
}
