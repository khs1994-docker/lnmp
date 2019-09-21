Function _exportPath($items){

  $env_path=[environment]::GetEnvironmentvariable("Path","user")

  Foreach ($item in $items)
  {
    $string=$(echo $env_path | select-string ("$item;").replace('\','\\'))

    if($string.Length -eq 0){
      write-host "
Add $item to system PATH env ...
    "
      [environment]::SetEnvironmentvariable("Path", "$item;$env_Path","User")
    }
  }
# $env:path=[environment]::GetEnvironmentvariable("Path","user") `
#           + ';' + [environment]::GetEnvironmentvariable("Path","machine") `
#           + ';' + [environment]::GetEnvironmentvariable("Path","process")
}
