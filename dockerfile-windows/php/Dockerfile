# FROM microsoft/windowsservercore:1903

FROM mcr.microsoft.com/windows/servercore:1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV PHP_VERSION 7.3.6

RUN $url = ('https://windows.php.net/downloads/releases/php-{0}-nts-Win32-VC15-x64.zip' -f $env:PHP_VERSION); \
	      Write-Host ('Downloading {0} ...' -f $url); \
	      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	      Invoke-WebRequest -Uri $url -OutFile 'php.zip'; \
       	\
        Write-Host 'Installing ...'; \
        Expand-Archive -Path php.zip -DestinationPath C:/PHP -Force; \
        \
        Write-Host 'Updating PATH ...'; \
	      $env:PATH = 'C:\php;' + $env:PATH; \
        [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); \
        \
        Write-Host 'Verifying install ...'; \
        Write-Host 'php -v'; php -v; \
        \
        Write-Host 'Removing ...'; \
        Remove-Item php.zip -Force; \
        \
        Write-Host 'Complete.'; \
    $url = ('https://github.com/deemru/php-cgi-spawner/releases/download/1.1.23/php-cgi-spawner.exe' -f $env:PHP_VERSION); \
            Write-Host ('Downloading {0} ...' -f $url); \
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
            Invoke-WebRequest -Uri $url -OutFile 'php-cgi-spawner.exe'; \
            Move-Item php-cgi-spawner.exe C:/php/

WORKDIR C:\\php

EXPOSE 9000

CMD ["php-cgi-spawner","php-cgi.exe","-c","c:/php/php.ini","9000","1"]
