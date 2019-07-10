Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

Function install_after(){

}

Function install($VERSION="2.22.0",$PreVersion=0){
  if($PreVersion){
  }else{
    $url="https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/Git-${GIT_VERSION}-64-bit.exe"
  }
  $name="git"
  $filename="Git-${GIT_VERSION}-64-bit.exe"
  $unzipDesc="git"

  if($(_command git)){
    $CURRENT_VERSION=(git --version).split(" ")[2].trim(".windows.1")

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
  # _cleanup ""
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  # Copy-item -r -force "" ""
  Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  # _exportPath "/path"
  # $env:Path = [environment]::GetEnvironmentvariable("Path")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  git --version
}

Function uninstall(){
  echo "Not Support"
  # _cleanup ""
}
