Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

#
# VC++ library
#
# @link https://support.microsoft.com/zh-cn/help/2977003/the-latest-supported-visual-c-downloads
# @link https://www.microsoft.com/en-us/download/details.aspx?id=40784
#

Function install_after(){

}

Function install($VERSION="16.0.0",$PreVersion=0){
  if($PreVersion){

  }else{
    $url="https://aka.ms/vs/16/release/VC_redist.x64.exe"
  }
  $name="VC_redist"
  $filename="VC_redist.x64.exe"
  $unzipDesc="VC_redist"

  if($(_command example)){
    $CURRENT_VERSION=""

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

  # echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  # example version
}

Function uninstall(){
  # echo "Not Support"
  # _cleanup ""
}
