Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

Function install($VERSION="0.12.0",$preVersion){
  if($preVersion){

  }
  $url="https://github.com/denoland/deno/releases/download/v${VERSION}/deno_win_x64.zip"
  $name="Deno"
  $filename="deno_win_x64_${VERSION}.zip"
  $unzipDesc="deno"

  if($(_command deno)){
    $CURRENT_VERSION=(deno version).split(":")[1].trim()

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
  _cleanup deno
  # 解压 zip 文件 Fix me
  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item deno/deno.exe C:\bin
  _cleanup deno
  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  deno version
}

Function uninstall(){
  Remove-item C:\bin\deno.exe
}
