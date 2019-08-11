Function _exportPath($items){
Foreach ($item in $items)
{
  $env_path=[environment]::GetEnvironmentvariable("Path","user")
  $string=$(echo $env_path | select-string ("$item;").replace('\','\\'))

  if($string.Length -eq 0){
    write-host "
Add $item to system PATH env ...
    "
    [environment]::SetEnvironmentvariable("Path", "$item;$env_Path","User")
  }
}
$env:path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine")
}
