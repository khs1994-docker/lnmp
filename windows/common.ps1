. "$PSScriptRoot/../.env.example.ps1"

if (Test-Path "$PSScriptRoot/../.env.ps1"){
  . "$PSScriptRoot/../.env.ps1"
}
