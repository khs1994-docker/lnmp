Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="68.0b9"){
  $url="https://ftp.mozilla.org/pub/firefox/releases/68.0b9/win64/en-US/Firefox%20Setup%2068.0b9.msi"
  $name="Firefox"
  $filename="Firefox Setup 68.0b9.msi"
  $unzipDesc="firefox"

  if($(_command "$env:ProgramFiles\Mozilla Firefox\firefox.exe")){
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
  & ls "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
}

Function uninstall(){
  & "$env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe"
}
