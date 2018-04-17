Function print_help_info(){
Write-Host "
get-version

5.5 {PATH}

5.6 {PATH}

$ git clone $HOME\lnmp\app\laravel

$ git clone -b 5.5    --depth=1 https://code.aliyun.com/khs1994-php/laravel-git.git laravel

$ git clone -b 5.5.39 --depth=1 https://code.aliyun.com/khs1994-php/laravel-git.git laravel

$ git clone -b 5.6    --depth=1 git@code.aliyun.com:khs1994-php/laravel-git.git laravel

$ git clone -b 5.6.14 --depth=1 git@code.aliyun.com:khs1994-php/laravel-git.git laravel

"
}

Function _get_version(){
  git ls-remote -t --refs https://code.aliyun.com/khs1994-php/laravel-git.git
}

if ($args -eq 'get-version'){
  _get_version
  exit
}

Function _clone($version){
  $temp_path = "$env:LNMP_PATH\app\temp\laravel${version}"
  if (Test-Path $temp_path){
    Write-Host "
Found Temp $temp_path

Now Clone laravel from $temp_path
"
    git clone $temp_path $args[1]
    exit
  }else{
    Write-Host "
Local Temp $temp_path not found

Now Clone from git then clone from local
"
    git clone -b $version --depth=1 https://code.aliyun.com/khs1994-php/laravel-git.git "$env:LNMP_PATH\app\temp\laravel$version"
    _clone $version
  }
}

if($args.Length -eq 2){
  if ($args[0] -eq '5.5'){
  _clone 5.5 $args[1]
  }elseif($args[0] -eq '5.6'){
  _clone 5.6 $args[1]
  }
}

print_help_info
