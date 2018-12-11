. "$PSScriptRoot/common.ps1"

################################################################################

Function print_help_info(){
  Write-Host "
Usage:

start     Start WNMP        [SOFT_NAME] [SOFT_NAME] ... [all]
restart   Restart WNMP      [SOFT_NAME] [SOFT_NAME] ... [all]
stop      Stop WNMP         [SOFT_NAME] [SOFT_NAME] ... [all]
status    Show WNMP status
ps        Show WNMP status

Example

lnmp-wnamp.ps1 start php nginx mysql wsl-redis

lnmp-wnamp.ps1 start common  UP COMMON_SOFT set in `.env.ps1` file.

lnmp-wnamp.ps1 stop all

lnmp-wnamp.ps1 restart nginx wsl-memcached
"
}

$source=$pwd

Function printInfo(){
  Write-Host "$args" -ForegroundColor Red
}

Function _stop($soft){
  switch ($soft){
    "nginx" {
      printInfo "Stop nginx..."
      taskkill /F /IM nginx.exe
      Write-Host "
      "
    }

    "php" {
       printInfo "Stop php-cgi..."
       taskkill /F /IM php-cgi-spawner.exe
       taskkill /F /IM php-cgi.exe
       Write-Host "
       "
    }

    "mysql" {
      printInfo "Stop MySQL..."
      net stop mysql
      Write-Host "
      "
    }

    "httpd" {
      printInfo "Stop HTTPD..."
      httpd -d C:/Apache24 -k stop
      Write-Host "
      "
    }

    "sshd" {
      printInfo "Stop sshd ..."
      Stop-Service sshd
      Write-Host "
      "
    }

    Default {
      wsl -d ${DistributionName} -u root lnmp-wsl stop $soft
    }
  }
}

Function _stop_wsl($soft){
  switch ($soft){
    "wsl-php" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop php
    }

    "wsl-nginx" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop nginx
    }

    "wsl-mysql" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop mysql
    }

    "wsl-httpd" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop httpd
    }

    "wsl-redis" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop redis
    }

    "wsl-memcached" {
      wsl -d ${DistributionName} -u root lnmp-wsl stop memcached
    }
  }
}

Function _stop_all(){
  _stop php
  _stop mysql
  _stop nginx
  _stop redis
  _stop memcached
  _stop mongodb
  _stop postgresql
  _stop httpd
}

################################################################################

Function _start($soft){
  switch ($soft) {
    "nginx" {
      # cd $NGINX_PATH
      printInfo "Start nginx..."
      nginx -p ${NGINX_PATH} -t
      RunHiddenConsole nginx -p ${NGINX_PATH}
      cd $source
      Write-Host "
      "
    }

    "mysql" {
      printInfo "Start MySQL..."
      net start mysql
      Write-Host "
      "
    }

     "php" {
       printInfo "Start php-cgi..."
       # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"
       # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9100 -c "$PHP_PATH"
       # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9200 -c "$PHP_PATH"
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9000 1
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9100 1
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9200 1
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9300 1
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9400 1
       php-cgi-spawner.exe "php-cgi.exe -c c:/php/php.ini" 9500 1
       Write-Host "
       "
     }

     "httpd" {
       printInfo "Start HTTPD..."
       httpd -t
       httpd -d C:/Apache24 -k start
       Write-Host "
       "
     }

     "sshd" {
       printInfo "Start SSHD..."
       Start-Service sshd
       Write-Host "
       "
     }

     Default {
       wsl -d ${DistributionName} -u root lnmp-wsl start $soft
     }
  }
}

Function _start_wsl($soft){
  switch ($soft){
    "wsl-php" {
      wsl -d ${DistributionName} -u root lnmp-wsl start php
    }

    "wsl-nginx" {
      wsl -d ${DistributionName} -u root lnmp-wsl start nginx
    }

    "wsl-mysql" {
      wsl -d ${DistributionName} -u root lnmp-wsl start mysql
    }

    "wsl-httpd" {
      wsl -d ${DistributionName} -u root lnmp-wsl start httpd
    }

    "wsl-redis" {
      wsl -d ${DistributionName} -u root lnmp-wsl start redis
    }

    "wsl-memcached" {
      wsl -d ${DistributionName} -u root lnmp-wsl start memcached
    }
  }
}

Function _start_all(){
  _start php
  _start mysql
  _start nginx
  _start redis
  _start memcached
  _start mongodb
  _start postgresql
  _start httpd
}

################################################################################

Function _status(){
  printInfo "nginx Status
  "
  Get-Process | Where-Object { $_.name -eq "nginx"}
  Write-Host "
  "
  printInfo "php-cgi Status
  "
  Get-Process | Where-Object { $_ -match "php-cgi"}
  Write-Host "
  "
  printInfo "MySQL Status
  "
  Get-Process | Where-Object { $_ -match "mysql"}
  Write-Host "
  "
  printInfo "Redis Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "redis"}
  Write-Host "
  "
  printInfo "MongoDB Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "mongod"}
  Write-Host "
  "
  printInfo "Memcached Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "memcached"}
  Write-Host "
  "
  printInfo "Apache Status
  "
  Get-Process | Where-Object { $_ -match "httpd"}
  Write-Host "
  "
  printInfo "SSHD Status
  "
  Get-Process | Where-Object { $_ -match "sshd"}
}

################################################################################

$global:WINDOWS_SOFT="nginx","php","mysql","redis","memcached","mongodb","postgresql","httpd","sshd"
$global:WSL_SOFT="wsl-nginx","wsl-php","wsl-httpd","wsl-mysql","wsl-redis","wsl-memcached"

if ($args.length -eq 1){
  if ($args[0] -eq 'status' -or $args[0] -eq 'ps'){
    _status
	exit
  }
}elseif($args.length -lt 2){
  print_help_info
  exit
}

$control, $other = $args

if ($other -eq 'common'){
  $other = $COMMON_SOFT
}

foreach ($soft in $other){
  switch ($control)
  {
  "stop" {
    switch ($soft)
    {
      {$_ -in $WINDOWS_SOFT} {
        _stop $soft
        break
      }

      {$_ -in $WSL_SOFT}{
        _stop_wsl $soft
        break
      }

      "all" {
        _stop_all
      }

      Default {
       print_help_info
      }
    }
  }

  "start" {
    switch ($soft)
    {
      {$_ -in $WINDOWS_SOFT} {
        _start $soft
        break
      }

      {$_ -in $WSL_SOFT}{
        _start_wsl $soft
        break
      }

      "all" {
        _start_all
      }

      Default {
        print_help_info
      }
    }
  }

  "restart" {
    switch ($soft)
    {
      {$_ -in $WINDOWS_SOFT} {
        _stop $soft
        _start $soft
        break
      }

      {$_ -in $WSL_SOFT}{
        _stop_wsl $soft
        _start_wsl $soft
        break
      }

      "all" {
        _stop_all
        _start_all
      }

      Default {
        print_help_info
      }
    }
  }

  Default {
    print_help_info
  }
 }
}
