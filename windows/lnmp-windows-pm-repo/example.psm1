Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

Function install_after(){

}

Function install($VERSION="x.y.z",$PreVersion=0){
  if($PreVersion){
    $VERSION=""
    $url=""
  }else{
    $url=""
  }
  $name="Example"
  $filename=""
  $unzipDesc="example"

  # _exportPath "/path"
  # $env:path=[environment]::GetEnvironmentvariable("Path","user") `
  #           + ';' + [environment]::GetEnvironmentvariable("Path","machine")

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
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force "" ""
  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  # _exportPath "/path"
  # $env:path=[environment]::GetEnvironmentvariable("Path","user") `
  #           + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  example version
}

Function uninstall($prune=0){
  echo "Not Support"
  # _cleanup ""
  # user data
  if($prune){
    # _cleanup ""
  }
}
