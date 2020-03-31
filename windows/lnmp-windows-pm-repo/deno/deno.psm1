Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  if($isPre){
    $VERSION=$preVersion
  }

  $url="https://github.com/denoland/deno/releases/download/v${VERSION}/deno-x86_64-pc-windows-msvc.zip"

  $filename="deno-x86_64-pc-windows-msvc_${VERSION}.zip"
  $unzipDesc="deno"

  if($(_command deno)){
    $CURRENT_VERSION=(deno --version).split(" ")[1].trim()

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
  _cleanup deno
  # 解压 zip 文件 Fix me
  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item deno/deno.exe C:\bin
  _cleanup deno
  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  deno --version
}

Function uninstall(){
  Remove-item C:\bin\deno.exe
}
