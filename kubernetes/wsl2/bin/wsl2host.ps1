<#
.SYNOPSIS
  get wsl2 host
.DESCRIPTION
  get wsl2 host
.EXAMPLE
  PS C:\> wsl2host
  get wsl2 host
.EXAMPLE
  PS C:\> wsl2host --write
  get wsl2 host and write hosts to C:\Windows\System32\drivers\etc\hosts
.INPUTS

.OUTPUTS

.NOTES
  get wsl2 host
#>

. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

$wsl2_ip=wsl -- bash -c "ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1"

Write-Output $wsl2_ip

if($args[0] -ne "--write"){
  exit
}

# 写入 wsl2host 到 C:\Windows\System32\drivers\etc\hosts

$hosts_path="C:\Windows\System32\drivers\etc\hosts"

Function _sudo($command){
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
  $encodedCommand = [Convert]::ToBase64String($bytes)

  start-process -FilePath powershell.exe `
    -ArgumentList "-encodedCommand","$encodedCommand" -Verb RunAs
}

""
"==> write hosts to [ $hosts_path ]"

$exists_hosts_content_array=get-content $hosts_path

for ($i = 0; $i -lt $exists_hosts_content_array.Count; $i++) {
  if($exists_hosts_content_array[$i] -eq '# add wsl2host by khs1994-docker/lnmp BEGIN'){
    $begin_line=$i;
  }

  if($exists_hosts_content_array[$i] -eq '# add wsl2host by khs1994-docker/lnmp END'){
    $end_line=$i;
    break
  }
}

if( $begin_line  -and $end_line){
  Write-Warning "==> old wsl2host already add on line: $begin_line - $end_line , update wsl2host ..."

  $exists_hosts_content_array[$begin_line + 1] = "$wsl2_ip wsl2 $WSL2_DOMAIN"

  Set-Content -Path $env:TEMP/.k8s-wsl2-hosts -Value $exists_hosts_content_array

  _sudo "cp $env:TEMP/.k8s-wsl2-hosts $hosts_path"

  exit
}

$hosts_content="
# add wsl2host by khs1994-docker/lnmp BEGIN
$wsl2_ip wsl2 $WSL2_DOMAIN
# add wsl2host by khs1994-docker/lnmp END
"

_sudo "echo `"$hosts_content`" | out-file -FilePath $hosts_path -Append -Encoding Unknown"
