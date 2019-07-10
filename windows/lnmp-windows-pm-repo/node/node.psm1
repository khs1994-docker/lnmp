Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

Function install_after(){
  npm config set prefix $env:ProgramData\npm
}

Function install($VERSION="12.6.0",$PreVersion=0){
  if($PreVersion){
  }else{
    $url="https://mirrors.ustc.edu.cn/node/v${VERSION}/node-v${VERSION}-win-x64.zip"
  }
  $name="node"
  $filename="node-v${VERSION}-win-x64.zip"
  $unzipDesc="node"

  if($(_command node)){
    $CURRENT_VERSION=(node --version).trim("v")

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
  _cleanup node
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir C:\node
  Copy-item -r -force "node\node-v${VERSION}-win-x64\*" "C:\node\"
  # Start-Process -FilePath $filename -wait
  _cleanup node

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "C:\node" "$env:ProgramData\npm"
  $env:Path = [environment]::GetEnvironmentvariable("Path")
  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  node --version
}

Function uninstall(){
  _cleanup C:\node "$env:ProgramData\npm"
}
