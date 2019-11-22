Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install_after(){

}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  $url="https://github.com/git-for-windows/git/releases/download/v${VERSION}.windows.1/Git-${GIT_VERSION}-64-bit.exe"
  $url="https://mirrors.huaweicloud.com/git-for-windows/v${VERSION}.windows.1/Git-${VERSION}-64-bit.exe"

  if($isPre){
    $VERSION=$preVersion
    # $url=$lwpm.preUrl
  }else{

  }

  $filename="Git-${GIT_VERSION}-64-bit.exe"
  $unzipDesc="git"

  if($(_command git)){
    $CURRENT_VERSION=(git --version).split(" ")[2].trim(".windows.1")

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
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

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  git --version
}

Function uninstall(){
  & $env:ProgramFiles\Git\unins000.exe
  # _cleanup ""
}
