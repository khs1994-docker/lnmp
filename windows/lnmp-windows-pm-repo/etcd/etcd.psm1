Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module getHttpCode

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

  $url=$url_mirror.replace('${VERSION}',${VERSION});
  if((_getHttpCode $url)[0] -eq 4){
      $url=$url.replace('${VERSION}',${VERSION});
  }

  $filename="etcd-v${VERSION}-windows-amd64.zip"
  $unzipDesc="etcd"

  if($(_command etcd)){
    $CURRENT_VERSION=(etcd --version).split(" ")[2]

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
  _cleanup etcd
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force etcd\etcd-v${VERSION}-windows-amd64\etcd.exe C:\bin\
  Copy-item -r -force etcd\etcd-v${VERSION}-windows-amd64\etcdctl.exe C:\bin\
  # Start-Process -FilePath $filename -wait
  _cleanup etcd

  # [environment]::SetEnvironmentvariable("", "", "User")

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  etcd --version
}

Function uninstall(){
  _cleanup C:\bin\etcd.exe C:\bin\etcdctl.exe
}
