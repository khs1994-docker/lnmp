@echo OFF
:: in case DelayedExpansion is on and a path contains !
setlocal DISABLEDELAYEDEXPANSION
php "%~dp0php-cs-fixer.phar" %*
