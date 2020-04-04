Import-Module downloader
Import-Module unzip
Import-Module command

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
  $url="https://github.com/yarnpkg/yarn/releases/download/v${VERSION}/yarn-${VERSION}.msi"
  $url="https://mirrors.huaweicloud.com/yarn/v${VERSION}/yarn-${VERSION}.msi"
  $filename="yarn-${VERSION}.msi"
  $unzipDesc="yarn"

  if($(_command yarn)){
    $CURRENT_VERSION=$(yarn --version)

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
  # _unzip $filename $unzipDesc
  # 安装 Fix me
  # Copy-item deno/deno.exe C:\bin

  Start-Process -FilePath $filename -wait

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  yarn --version
}

Function uninstall(){
  ""
  # Remove-item
}
