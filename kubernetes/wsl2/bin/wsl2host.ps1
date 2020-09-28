<#
.SYNOPSIS
  get wsl2 host
.DESCRIPTION

  get wsl2 host

  $ wsl2host

  get wsl2 host and write hosts to C:\Windows\System32\drivers\etc\hosts

  $ wsl2host --write [ -f ]
#>

. $PSScriptRoot/../.env.example.ps1
. $PSScriptRoot/../.env.ps1

Import-Module $PSScriptRoot/WSL-K8S.psm1

$wsl2_ip = Get-WSL2IP

if(!$wsl2_ip){
  write-host "==> get wsl2 ip error" -ForegroundColor Red

  exit 1
}

$env:WSL2_IP = $wsl2_ip
$env:BASH_ENV = "/etc/bash.bashrc"

$env:WSLENV = "BASH_ENV/u:WSL2_IP/u"

Write-Output $wsl2_ip

if ($args[0] -ne "--write") {
  exit
}

$global:FORCE = $false

foreach ($arg in $args ) {
  if ($arg -eq "--force" -or $arg -eq "-f") {
    $global:FORCE = $true
  }
}

# 写入 wsl2host 到 C:\Windows\System32\drivers\etc\hosts

$hosts_path = "C:\Windows\System32\drivers\etc\hosts"

Function _sudo($command) {
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
  $encodedCommand = [Convert]::ToBase64String($bytes)

  start-process -FilePath powershell.exe `
    -ArgumentList "-encodedCommand", "$encodedCommand" -Verb RunAs -WindowStyle Minimized
}

Function _write_host() {
  ping -n 1 wsl2 | out-null

  if ($? -and !$global:FORCE) {
    write-host "==> WSL2 ip not changed, skip" -ForegroundColor Yellow
    return
  }

  write-host "==> write WSL2 ip to [ $hosts_path ]" -ForegroundColor Green

  write-host "==> Requires Administrator allow" -ForegroundColor Red

  $exists_hosts_content_array = get-content $hosts_path

  for ($i = 0; $i -lt $exists_hosts_content_array.Count; $i++) {
    if ($exists_hosts_content_array[$i] -eq '# add wsl2host by khs1994-docker/lnmp BEGIN') {
      $begin_line = $i;
    }

    if ($exists_hosts_content_array[$i] -eq '# add wsl2host by khs1994-docker/lnmp END') {
      $end_line = $i;
      break
    }
  }

  if ( $begin_line -and $end_line) {
    Write-Warning "==> old wsl2host already add on line: $begin_line - $end_line , update wsl2host to new $wsl2_ip ..."

    # 清空 begin - end 之间的内容

    for ($i = 1; $i -lt $end_line; $i++) {
      if ($i -gt $begin_line) {
        $exists_hosts_content_array[$i] = $null
      }
    }

    $ErrorActionPreference = "SilentlyContinue"

    $exists_hosts_content_array[$begin_line + 1] = "
$wsl2_ip wsl2 wsl.k8s.khs1994.com wsl2.k8s.khs1994.com $WSL2_DOMAIN
"

    for ($i = 1; $i -le 20; $i++) {
      if (get-variable WSL2_DOMAIN_${i}) {
        $hosts = (get-variable WSL2_DOMAIN_${i}).value
        $exists_hosts_content_array[$begin_line + 1] += "$wsl2_ip $hosts`n"
      }
    }

    Set-Content -Path $HOME/.khs1994-docker-lnmp/.wsl-k8s-hosts -Value $exists_hosts_content_array

    _sudo "cp $HOME/.khs1994-docker-lnmp/.wsl-k8s-hosts $hosts_path"

    exit
  }

  $hosts_content = "
# add wsl2host by khs1994-docker/lnmp BEGIN
$wsl2_ip wsl2 wsl.k8s.khs1994.com wsl2.k8s.khs1994.com $WSL2_DOMAIN
"

  for ($i = 1; $i -le 20; $i++) {
    if (get-variable WSL2_DOMAIN_${i}) {
      $hosts = (get-variable WSL2_DOMAIN_${i}).value
      $hosts_content += "$wsl2_ip $hosts`n"
    }
  }

  $hosts_content += "# add wsl2host by khs1994-docker/lnmp END"

  _sudo "echo `"$hosts_content`" | out-file -FilePath $hosts_path -Append -Encoding Default"
}

_write_host

$ErrorActionPreference = "continue"
