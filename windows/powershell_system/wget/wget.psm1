Import-Module command

$global:USER_AGENT="5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3828.0 Safari/537.36"

Function _wget($src,$des,$wsl=$true){
  Invoke-WebRequest -uri $src -OutFile $des -UserAgent $USER_AGENT
  Unblock-File $des
}
