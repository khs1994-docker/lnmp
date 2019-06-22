# FROM microsoft/windowsservercore:1903

FROM mcr.microsoft.com/windows/servercore:1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV MYSQL_VERSION 8.0.16

RUN $url = ('https://dev.mysql.com/get/Downloads/MySQL-${0}/mysql-${1}-winx64.zip' -f '8.0' $env:MYSQL_VERSION); \
	      Write-Host ('Downloading {0} ...' -f $url); \
	      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	      Invoke-WebRequest -Uri $url -OutFile 'mysql.zip'; \
       	\
        Write-Host 'Installing ...'; \
        Expand-Archive -Path mysql.zip -DestinationPath C:/ -Force; \
        Move-Item C:/mysql-${env:MYSQL_VERSION}-winx64 C:/mysql; \
        \
        Write-Host 'Updating PATH ...'; \
	      $env:PATH = 'C:\mysql;' + $env:PATH; \
        [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); \
        \
        Write-Host 'Verifying install ...'; \
        Write-Host 'mysql --version'; mysql --version; \
        \
        Write-Host 'Removing ...'; \
        Remove-Item mysql.zip -Force; \
        \
        Write-Host 'Complete.';

WORKDIR C:\\mysql

EXPOSE 3306

VOLUME C:\\mysql\\data

CMD ["mysqld"]
