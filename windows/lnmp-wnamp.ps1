# ！！！！！！！！！！！！！！！
# ！！ 务必设置软件目录   ！！
#！！！！！！！！！！！！！！！

# $NGINX_PATH="C:/nginx-1.13.8"
$PHP_PATH="C:/php"
$LNMP_PATH="$HOME/lnmp"

################################################################################

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

    Default {
      bash lnmp-wsl.sh stop $soft
    }
  }
}

Function _stop_wsl($soft){
  switch ($soft){
    "wsl-php" {
      bash lnmp-wsl.sh stop php
    }

    "wsl-nginx" {
      bash lnmp-wsl.sh stop nginx
    }

    "wsl-mysql" {
      bash lnmp-wsl.sh stop mysql
    }

    "wsl-httpd" {
      bash lnmp-wsl.sh stop httpd
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
}

################################################################################

Function _start($soft){
  switch ($soft) {
    "nginx" {
      # cd $NGINX_PATH
      printInfo "Start nginx..."
      RunHiddenConsole nginx -p C:/nginx
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
       RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"
       Write-Host "
       "
     }

     Default {
       bash lnmp-wsl.sh start $soft
     }
  }
}

Function _start_wsl($soft){
  switch ($soft){
    "wsl-php" {
      bash lnmp-wsl.sh start php
    }

    "wsl-nginx" {
      bash lnmp-wsl.sh start nginx
    }

    "wsl-mysql" {
      bash lnmp-wsl.sh start mysql
    }

    "wsl-httpd" {
      bash lnmp-wsl.sh start httpd
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
  printInfo "Apache Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "httpd"}
}

################################################################################

switch ($args[0])
{
  "stop" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql","redis","memcached","mongodb","postgresql"} {
        _stop $args[1]
        break
      }

      {$_ -in "wsl-nginx","wsl-php","wsl-httpd","wsl-mysql"}{
        _stop_wsl $args[1]
        break
      }

      Default {
        _stop_all
      }
    }
  }

  "start" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql","redis","memcached","mongodb","postgresql"} {
        _start $args[1]
        break
      }

      {$_ -in "wsl-nginx","wsl-php","wsl-httpd","wsl-mysql"}{
        _start_wsl $args[1]
        break
      }

      Default {
        _start_all
      }
    }
  }

  "restart" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql","redis","memcached","mongodb","postgresql"} {
        _stop $args[1]
        _start $args[1]
        break
      }

      {$_ -in "wsl-nginx","wsl-php","wsl-httpd","wsl-mysql"}{
        _stop_wsl $args[1]
        _start_wsl $args[1]
        break
      }

      Default {
        _stop_all
        _start_all
      }
    }
  }

  {$_ -in "status","ps"} {
     _status
     break
  }

  Default {
     Write-Host "start     Start WNMP
restart   Restart WNMP
stop      Stop WNMP
status    Show WNMP status
ps        Show WNMP status
"
  }
}
