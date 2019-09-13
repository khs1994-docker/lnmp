Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install_after(){
  npm config set prefix $env:ProgramData\npm
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VERSION=$preVersion
  }else{

  }

  $url="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/v${VERSION}/node-v${VERSION}-win-x64.zip"

  $filename="node-v${VERSION}-win-x64.zip"
  $unzipDesc="node"

  _exportPath "$env:ProgramData\node","$env:ProgramData\npm"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  if($(_command $env:ProgramData\node\node.exe)){
    $CURRENT_VERSION=(& "$env:ProgramData\node\node.exe" --version).trim("v")

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
  _cleanup node
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir "$env:ProgramData\node"
  Copy-item -r -force "node\node-v${VERSION}-win-x64\*" "$env:ProgramData\node\"
  # Start-Process -FilePath $filename -wait
  _cleanup node

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "$env:ProgramData\node","$env:ProgramData\npm"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  node.exe --version
}

Function uninstall(){
  _cleanup "$env:ProgramData\node"
  # user data
  # _cleanup "$env:ProgramData\npm"
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\releases.ps1

  $latestVersion=getLatestRelease $githubRepo

  ConvertFrom-Json -InputObject @"
{
"Package": "$name",
"Version": "$stableVersion",
"PreVersion": "$preVersion",
"LatestVersion": "$latestVersion",
"LatestPreVersion": "$latestPreVersion",
"HomePage": "$homepage",
"Releases": "$releases",
"Bugs": "$bug",
"Description": "$description"
}
"@
}

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
