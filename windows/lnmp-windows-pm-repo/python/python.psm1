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
    $url="https://www.python.org/ftp/python/3.8.2/python-${VERSION}-amd64.exe"
    $url="https://mirrors.huaweicloud.com/python/3.8.2/python-${VERSION}-amd64.exe"
  }else{
    $url="https://www.python.org/ftp/python/${VERSION}/python-${VERSION}-amd64.exe"
    $url="https://mirrors.huaweicloud.com/python/${VERSION}/python-${VERSION}-amd64.exe"
  }

  $filename="python-${VERSION}-amd64.exe"
  $unzipDesc="python"

  _exportPath "${env:ProgramData}\Python","${env:ProgramData}\Python\Scripts"

  if($(_command python)){
    $CURRENT_VERSION=($(python --version) -split " ")[1]

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

  # https://docs.python.org/3.7/using/windows.html#installing-without-ui
  Start-Process $filename -Wait `
  		-ArgumentList @( `
        '/quiet', `
        'InstallAllUsers=1', `
        "DefaultAllUsersTargetDir=${env:ProgramData}\Python", `
        "DefaultJustForMeTargetDir=${env:ProgramData}\Python", `
        "TargetDir=${env:ProgramData}\Python", `
        'PrependPath=1', `
        'Shortcuts=0', `
        'Include_doc=0', `
        'Include_pip=1', `
        'Include_test=0' `
  );

  _exportPath "${env:ProgramData}\Python","${env:ProgramData}\Python\Scripts"

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  python --version
}

Function uninstall(){
  "Not Support"
}
