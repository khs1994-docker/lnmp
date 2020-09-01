. "$PSScriptRoot/../bin/common.ps1"

################################################################################

$LNMP_WSL_CMD = wsl -d ${DistributionName} -- wslpath "'$PSScriptRoot\..\wsl\lnmp-wsl'";

Function print_help_info() {
  Write-Host "
Usage:

start     Start WNMP        [SOFT_NAME] [SOFT_NAME] ...
restart   Restart WNMP      [SOFT_NAME] [SOFT_NAME] ...
stop      Stop WNMP         [SOFT_NAME] [SOFT_NAME] ...
status    Show WNMP status
ps        Show WNMP status

Example

lnmp-wnamp.ps1 start php nginx mysql wsl-redis

lnmp-wnamp.ps1 start common  <start COMMON_SOFT, please set env in `.env.ps1` file>

lnmp-wnamp.ps1 stop all

lnmp-wnamp.ps1 restart nginx wsl-memcached
"
}

$EXEC_CMD_DIR = $pwd

Function printInfo($info, $color = 'Red') {
  Write-Host "==> $info" -ForegroundColor $color
}

Function _stop($soft) {
  switch ($soft) {
    "nginx" {
      printInfo "Stop nginx..." Red
      start-process "taskkill" -ArgumentList "/F", "/IM", "nginx.exe" -Verb RunAs
      Write-Host "
      "
    }

    "php" {
      printInfo "Stop php-cgi..." Red
      taskkill /F /IM php-cgi-spawner.exe
      taskkill /F /IM php-cgi.exe
      Write-Host "
       "
    }

    "mysql" {
      printInfo "Stop MySQL..." Red
      start-process "net" -ArgumentList "stop", "mysql" -Verb RunAs
      Write-Host "
      "
    }

    "httpd" {
      printInfo "Stop HTTPD..." Red
      httpd -d C:/Apache24 -k stop
      Write-Host "
      "
    }

    Default {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop $soft
    }
  }
}

Function _stop_wsl($soft) {
  switch ($soft) {
    "wsl-php" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop php
    }

    "wsl-nginx" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop nginx
    }

    "wsl-mysql" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop mysql
    }

    "wsl-httpd" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop httpd
    }

    "wsl-redis" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop redis
    }

    "wsl-memcached" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD stop memcached
    }
  }
}

################################################################################

Function _start($soft) {
  switch ($soft) {
    "nginx" {
      # cd $NGINX_PATH
      printInfo "Start nginx..." Green
      nginx -p ${NGINX_PATH} -t
      start-process "nginx" -ArgumentList "-p", "${NGINX_PATH}" -Verb RunAs -WindowStyle Hidden
      cd $EXEC_CMD_DIR
      Write-Host "
      "
    }

    "mysql" {
      printInfo "Start MySQL..." Green
      # net start mysql
      start-process "net" -ArgumentList "start", "mysql" -Verb RunAs
      Write-Host "
      "
    }

    "php" {
      printInfo "Start php-cgi..." Green
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9100 -c "$PHP_PATH"
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9200 -c "$PHP_PATH"
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9000 1
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9100 1
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9200 1
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9300 1
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9400 1
      php-cgi-spawner.exe "c:/php/php-cgi.exe -c c:/php/php.ini" 9500 1
      Write-Host "
       "
    }

    "php-pre" {
      printInfo "Start php-cgi..." Green
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9000 -c "$PHP_PATH"
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9100 -c "$PHP_PATH"
      # RunHiddenConsole php-cgi.exe -b 127.0.0.1:9200 -c "$PHP_PATH"
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9000 1
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9100 1
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9200 1
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9300 1
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9400 1
      php-cgi-spawner.exe "c:/php-pre/php-cgi.exe -c c:/php-pre/php.ini" 9500 1
      Write-Host "
      "
    }

    "httpd" {
      printInfo "Start HTTPD..." Green
      httpd -t
      httpd -d C:/Apache24 -k start
      Write-Host "
       "
    }

    Default {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start $soft
    }
  }
}

Function _start_wsl($soft) {
  switch ($soft) {
    "wsl-php" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start php
    }

    "wsl-nginx" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start nginx
    }

    "wsl-mysql" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start mysql
    }

    "wsl-httpd" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start httpd
    }

    "wsl-redis" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start redis
    }

    "wsl-memcached" {
      wsl -d ${DistributionName} -u root $LNMP_WSL_CMD start memcached
    }
  }
}

################################################################################

Function _status() {
  printInfo "nginx Status
  "
  Get-Process | Where-Object { $_.name -eq "nginx" }
  Write-Host "
  "
  printInfo "php-cgi Status
  "
  Get-Process | Where-Object { $_ -match "php-cgi" }
  Write-Host "
  "
  printInfo "MySQL Status
  "
  Get-Process | Where-Object { $_ -match "mysql" }
  Write-Host "
  "
  printInfo "Redis Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "redis" }
  Write-Host "
  "
  printInfo "MongoDB Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "mongod" }
  Write-Host "
  "
  printInfo "Memcached Status (WSL)
  "
  Get-Process | Where-Object { $_ -match "memcached" }
  Write-Host "
  "
  printInfo "HTTPD Status
  "
  Get-Process | Where-Object { $_ -match "httpd" }
  Write-Host "
  "
}

################################################################################

$WINDOWS_SOFT = "nginx", "php", "php-pre", "mysql", "mongodb", "postgresql", "httpd", "sshd"
$WSL_SOFT = "wsl-nginx", "wsl-php", "wsl-httpd", "wsl-mysql", "wsl-redis", "wsl-memcached"

if ($args.length -eq 1) {
  if ($args[0] -eq 'status' -or $args[0] -eq 'ps') {
    _status
    exit
  }
}
elseif ($args.length -lt 2) {
  print_help_info
  exit
}

$control, $other = $args

if ($other -eq 'common') {
  $other = $COMMON_SOFT
}

foreach ($soft in $other) {
  switch ($control) {
    "stop" {
      switch ($soft) {
        { $_ -in $WINDOWS_SOFT } {
          _stop $soft
          break
        }

        { $_ -in $WSL_SOFT } {
          _stop_wsl $soft
          break
        }

        Default {
          print_help_info
        }
      }
    }

    "start" {
      switch ($soft) {
        { $_ -in $WINDOWS_SOFT } {
          _start $soft
          break
        }

        { $_ -in $WSL_SOFT } {
          _start_wsl $soft
          break
        }

        Default {
          print_help_info
        }
      }
    }

    "restart" {
      switch ($soft) {
        { $_ -in $WINDOWS_SOFT } {
          _stop $soft
          _start $soft
          break
        }

        { $_ -in $WSL_SOFT } {
          _stop_wsl $soft
          _start_wsl $soft
          break
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
