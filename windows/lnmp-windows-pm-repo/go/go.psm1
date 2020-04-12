Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'
$insert_path=$lwpm.path

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  if($isPre){
    $VERSION=$pre_version
  }

  $url=$url.replace('${VERSION}',${VERSION});

  $filename="go${VERSION}.windows-amd64.zip"
  $unzipDesc="go"

  [environment]::SetEnvironmentvariable("GOPATH", "$HOME\go", "User")
  _exportPath "C:\go\bin","C:\Users\$env:username\go\bin"

  if($(_command go)){
    $CURRENT_VERSION=($(go version) -split " ")[2].trim("go")

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

  _cleanup go

  _unzip $filename $unzipDesc

  # 安装 Fix me

  _cleanup C:\go
  Copy-item -r -force go/go C:\
  _cleanup go

  [environment]::SetEnvironmentvariable("GOPATH", "$HOME\go", "User")
  _exportPath "C:\go\bin","C:\Users\$env:username\go\bin"

  "==> Checking ${name} ${VERSION} install ..."

  # 验证 Fix me

  go version
}

Function uninstall(){
  _cleanup C:\go
}
