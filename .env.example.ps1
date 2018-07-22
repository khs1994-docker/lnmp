#
# You Can overwrite this file in .env.ps1
#

$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin'

$global:CI_HOST="ci.khs1994.com:10000"

# wsl name $ wslconfig /l
$global:DistributionName="debian"

$global:TZ='Asia/Shanghai'
