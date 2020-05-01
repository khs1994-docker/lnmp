Function _command($command){
  if ($command -eq "wsl"){
    wsl curl -V | out-null

    return $?
  }else{
    $result = iex "get-command $command -ErrorAction `"SilentlyContinue`""

    if($result){
      return $true
    }

    return $false
  }
}
