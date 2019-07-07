Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

# $global:GOLANG_VERSION="1.13beta1"
# $global:GOLANG_VERSION="1.12rc1"
# $global:GOLANG_VERSION="1.12.5"

Function install($VERSION="1.13beta1"){
  $url="https://studygolang.com/dl/golang/go${VERSION}.windows-amd64.zip"
  $name="Go"
  $filename="go${VERSION}.windows-amd64.zip"
  $unzipDesc="go"

  if($(_command go)){
    $CURRENT_VERSION=($(go version) -split " ")[2].trim("go")

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
  _cleanup go

  _unzip $filename $unzipDesc
  # 安装 Fix me
  Copy-item -r -force go/go C:\
  cleanup go

  [environment]::SetEnvironmentvariable("GOPATH", "$HOME\go", "User")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  go version
}

Function uninstall(){
  _cleanup C:\go
}
