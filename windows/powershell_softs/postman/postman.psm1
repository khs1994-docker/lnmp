Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="7.2.2"){
  $url="https://dl.pstmn.io/download/latest/win64"
  $name="Postman"
  $filename="Postman-win64-${VERSION}-Setup.exe"
  $unzipDesc="postman"

  if($(_command "$env:APPDATA\..\Local\Postman\app-${VERSION}\Postman.exe")){
    echo "==> $name $VERSION already install"
    return
  }

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _cleanup ""
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  # Copy-item -r -force "" ""
  Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & Get-Command $env:APPDATA\..\Local\Postman\app-${VERSION}\Postman.exe
}

Function uninstall(){
  echo "Not Support"
}
