Function _exportPath($items){

  $env_path=[environment]::GetEnvironmentvariable("Path","user")

  Foreach ($item in $items)
  {
    $env_array=$env_path.split(';')

    if($env_array.IndexOf($item) -eq -1){
      "Add $item to system PATH env ...
"
      [environment]::SetEnvironmentvariable("Path", "$item;$env_Path","User")
    }
  }

$env_path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine") `
          + ';' + [environment]::GetEnvironmentvariable("Path","process")

$env_path=$env_path.split(';')

$env:path="C:\bin;";

Foreach ($item in $env_Path)
{
  if($env:path.split(';').indexof($item) -eq -1){
    $env:path+="${item};"
  }
}

}
