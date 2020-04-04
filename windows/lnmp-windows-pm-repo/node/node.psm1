Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

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

Function install_after(){
  npm config set prefix $env:ProgramData\npm
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }
  if($isPre){
    $VERSION=$pre_version
  }else{

  }

  $url=$url_mirror.replace('${VERSION}',${VERSION});

  $filename="node-v${VERSION}-win-x64.zip"
  $unzipDesc="node"

  _exportPath "$env:ProgramData\node","$env:ProgramData\npm"

  [environment]::SetEnvironmentvariable("NODE_PATH", "$env:ProgramData\npm\node_modules", "User");

  if($(_command $env:ProgramData\node\node.exe)){
    $CURRENT_VERSION=(& "$env:ProgramData\node\node.exe" --version).trim("v")

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
  _cleanup node
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir "$env:ProgramData\node"
  Copy-item -r -force "node\node-v${VERSION}-win-x64\*" "$env:ProgramData\node\"
  # Start-Process -FilePath $filename -wait
  _cleanup node

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "$env:ProgramData\node","$env:ProgramData\npm"

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  node.exe --version
}

Function uninstall(){
  _cleanup "$env:ProgramData\node"
  # user data
  # _cleanup "$env:ProgramData\npm"
}
