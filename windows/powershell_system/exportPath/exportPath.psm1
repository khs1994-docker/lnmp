Function _exportPath($items){
  if(!($IsWindows)){
    return
  }

  $env_path=[environment]::GetEnvironmentvariable("Path","user")
  $env_path_array=$env_path.split(';') | Sort-Object -unique

  Foreach ($item in $items)
  {
    if(!$item){
      continue;
    }

    $item = iex "echo $item"

    if($env_path_array.IndexOf($item) -eq -1){
      Write-Host "==> Add [ $item ] to system PATH env ..." -ForegroundColor Green

      [environment]::SetEnvironmentvariable("Path", "$item;$env_Path","User")
    }
  }

$env_path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine") `
          + ';' + [environment]::GetEnvironmentvariable("Path","process")

$env_path_array=$env_path.split(';')

$env:path="C:\bin;";

Foreach ($item in $env_path_array)
{
  if($env:path.split(';').indexof($item) -eq -1){
    $env:path+="${item};"
  }
}

}
