Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  if($isPre){
    $VERSION=$preVersion
  }

  $url="https://studygolang.com/dl/golang/go${VERSION}.windows-amd64.zip"

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

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\repos.ps1

  $latestVersion=(getLatestTag $githubRepo 4 22).trim("go")

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
