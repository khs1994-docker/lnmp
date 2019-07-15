Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="6.2.1",$PreVersion=0){
  if($PreVersion){
    $VERSION="7.0.0-preview.1"
  }
  $url="https://github.com/PowerShell/PowerShell/releases/download/v${VERSION}/PowerShell-${VERSION}-win-x64.msi"
  $name="PowerShell"
  $filename="PowerShell-${VERSION}-win-x64.msi"
  $unzipDesc="PowerShell"

  _exportPath "$env:ProgramFiles\PowerShell\7-preview"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  if($(_command pwsh)){
    $CURRENT_VERSION=(pwsh --version).split(" ")[1]

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
  _exportPath "$env:ProgramFiles\PowerShell\7-preview"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  pwsh --version
}

Function uninstall(){
  echo "Not Support"
}
