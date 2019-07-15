Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

Function install_after(){

}

Function install($VERSION="1.8.6",$PreVersion=0){
  if($PreVersion){
  }else{
    $url="https://github.com/composer/composer/releases/download/${VERSION}/composer.phar"
  }
  $name="composer"
  $filename="composer.phar"
  $unzipDesc="composer"

  _exportPath "$env:ProgramData\ComposerSetup\bin\", `
              "$HOME\AppData\Roaming\Composer\vendor\bin"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  if($(_command composer)){
    $CURRENT_VERSION=(composer --version).split(" ")[2]

    if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    }else{
        composer self-update $VERSION
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
  _mkdir "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "${PSScriptRoot}\composer" "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "${PSScriptRoot}\composer.bat" "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "composer.phar" "$env:ProgramData\ComposerSetup\bin\"
  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "$env:ProgramData\ComposerSetup\bin\", `
              "$HOME\AppData\Roaming\Composer\vendor\bin"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  composer --version
}

Function uninstall($prune=0){
  _sudo "remove-item -r -force $env:ProgramData\ComposerSetup"
  # user data
  if($prune){
    _cleanup "$HOME\AppData\Roaming\Composer"
    _cleanup "$HOME\AppData\Local\Composer"
  }
}
