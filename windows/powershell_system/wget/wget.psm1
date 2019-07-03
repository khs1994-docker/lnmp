Import-Module command

Function _wget($src,$des,$wsl=$true){
  $useWSL=_command wsl -and $wsl

  if ($useWSL -eq "True"){

    Write-host "

use WSL curl download file ...
"

    wsl -- curl -L $src -o $des --user-agent $USER_AGENT

    return
  }

  Invoke-WebRequest -uri $src -OutFile $des -UserAgent $USER_AGENT
  Unblock-File $des
}
