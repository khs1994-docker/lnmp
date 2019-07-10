Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module ln
Import-Module sudo

$global:HTTPD_MOD_FCGID_VERSION="2.3.10"

Function after_install(){
  $a=Select-String 'IncludeOptional conf.d/' C:\Apache24\conf\httpd.conf

  if ($a.Length -eq 0){
    echo "==> Add config in C:\Apache24\conf\httpd.conf"

    echo ' ' | out-file -Append C:\Apache24\conf\httpd.conf
    echo "IncludeOptional conf.d/*.conf
LoadModule ssl_module modules/mod_ssl.so
LoadModule headers_module modules/mod_headers.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
" | out-file -Append C:\Apache24\conf\httpd.conf
  }
}

Function install($VERSION="2.4.39",$preVersion=0){
  if($preVersion){

  }
  $url="https://www.apachelounge.com/download/VS16/binaries/httpd-${VERSION}-win64-VS16.zip"
  $name="HTTPD"
  $filename="httpd-${VERSION}-win64-VS16.zip"
  $unzipDesc="httpd"

  if($(_command httpd)){
    $CURRENT_VERSION=($(httpd -v) -split " ")[2].trim("Apache/")

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

  _downloader `
    "https://www.apachelounge.com/download/VS16/modules/mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16.zip" `
    "mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16.zip" `
    "httpd_mod_fcgid" `
    ${HTTPD_MOD_FCGID_VERSION}

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  _cleanup $unzipDesc
  _unzip $filename $unzipDesc
  # 安装 Fix me
  _mkdir C:\Apache24
  Copy-item -r -force "httpd\Apache24" "C:\"
  if (!(Test-Path C:\Apache24\modules\mod_fcgid.so)){
    _unzip mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16.zip `
           mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16

    copy-item mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16\mod_fcgid-${HTTPD_MOD_FCGID_VERSION}\mod_fcgid.so `
              C:\Apache24\modules

    _cleanup mod_fcgid-${HTTPD_MOD_FCGID_VERSION}-win64-VS16
  }

  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  $HTTPD_IS_RUN=0

  get-service Apache2.4 | out-null

  if (!($?)){
      _sudo "httpd -k install"
      $HTTPD_IS_RUN=1
  }

  mkdir C:\Apache24\conf.d | out-null

  _ln C:\Apache24\conf.d $env:USERPROFILE\lnmp\windows\httpd

  _ln C:\Apache24\logs $env:USERPROFILE\lnmp\windows\logs\httpd

  _cleanup $unzipDesc

  after_install

  _exportPath "C:\Apache24\bin"
  $env:Path = [environment]::GetEnvironmentvariable("Path")

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  httpd -v
}

Function uninstall(){
  _sudo "httpd -k uninstall"
  _cleanup C:\Apache24
}
