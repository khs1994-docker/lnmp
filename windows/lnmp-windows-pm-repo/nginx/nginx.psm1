Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath
Import-Module getHttpCode

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$urlMirror=$lwpm.urlMirror

Function install_after(){
  _mkdir C:\nginx\conf\conf.d

  _ln C:\nginx\conf\conf.d $home\lnmp\windows\nginx

  _ln C:\nginx\logs $home\lnmp\windows\logs\nginx

  Get-Process nginx -ErrorAction "SilentlyContinue" | out-null

  if (!($?)){
    echo ' ' | out-file -Append $home\lnmp\windows\logs\nginx\access.log -ErrorAction "SilentlyContinue"
    echo ' ' | out-file -Append $home\lnmp\windows\logs\nginx\error.log -ErrorAction "SilentlyContinue"
  }
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VERSION=$preVersion
  }else{

  }

  $url=$urlMirror.replace('${VERSION}',${VERSION});
  if((_getHttpCode $url)[0] -eq 4){
    $url=$url.replace('${VERSION}',${VERSION});
  }

  $filename="nginx-${VERSION}.zip"
  $unzipDesc="nginx"

  _exportPath "C:\nginx"

  cp $PSScriptRoot/../../config/nginx.conf C:/nginx/conf

  if($(_command nginx)){
    nginx -v > $env:TEMP/.nginx.version 2>&1
    $CURRENT_VERSION=$(cat $env:TEMP/.nginx.version).split(' ')[2].split('/')[1]
    rm -r $env:TEMP/.nginx.version
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
  _cleanup nginx
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir C:\nginx
  Copy-item -r -force "nginx\nginx-${VERSION}\*" "C:\nginx"
  # Start-Process -FilePath $filename -wait
  _cleanup nginx

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "C:\nginx"

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  nginx -v
}

Function uninstall(){
  _cleanup C:\nginx
}
