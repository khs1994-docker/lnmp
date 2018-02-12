# ！！！！！！！！！！！！！！！
# ！！ 务必设置软件目录   ！！
#！！！！！！！！！！！！！！！

$NGINX_PATH="C:/nginx-1.13.8"
$PHP_PATH="C:/php"

##########################################

$source=$pwd

Function printInfo(){
  Write-Host "$args" -ForegroundColor Red
}

Function _stop(){
  printInfo "Stop nginx..."

  taskkill /F /IM nginx.exe

  Write-Host "
  "
  # nginx -s stop
  printInfo "Stop MySQL..."

  net stop mysql

  Write-Host "
  "
  printInfo "Stop php-cgi..."

  taskkill /F /IM php-cgi.exe
}

Function _start(){
  cd $NGINX_PATH
  printInfo "Start nginx..."
  start nginx
  cd $source

  printInfo "Start MySQL..."
  net start mysql

  printInfo "Start php-cgi..."
  RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"
  cd $source
}

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
}

Function startSingle(){
  switch ($args[0])
  {
    "nginx" {
      cd $NGINX_PATH ; printInfo "Start nginx..."

      start nginx

      cd $source
      break
    }
    "php" {
      printInfo "Start php-cgi..."

      RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"

      break
    }
    "mysql" {
      printInfo "Start MySQL..."

      net start mysql

      break
    }
  }
}

Function stopSingle(){
  switch ($args[0])
  {
    "nginx" {
      cd $NGINX_PATH ; printInfo "Stop nginx..."

      taskkill /F /IM nginx.exe

      cd $source
      break
    }
    "php" {
      printInfo "Stop php-cgi..."

        taskkill /F /IM php-cgi.exe

      break
    }
    "mysql" {
      printInfo "Stop MySQL..."

      net stop mysql

      break
    }
  }
}

Function restartSingle(){
  switch ($args[0])
  {
    {$_ -in "nginx","php","mysql"} {
      stopSingle $args[0]
      startSingle $args[0]
    }
  }
}

switch ($args[0])
{
  "stop" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql"} {
        stopSingle $args[1]
        break
      }
      Default {
        _stop
      }
    }
  }
  "start" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql"} {
        startSingle $args[1]
        break
      }
      Default {
        _start
      }
    }
  }

  "restart" {
    switch ($args[1])
    {
      {$_ -in "nginx","php","mysql"} {
        restartSingle $args[1]
        break
      }
      Default {
        _stop
        _start
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
