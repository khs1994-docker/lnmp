#
# https://github.com/laravel/laravel
#

if ($args -contains 'new' ){
  if ($args.Count -lt 2 ){
    exit 1
  }
}

if (!(Test-Path ${LARAVEL_PATH})){
  echo ""
  echo "${LARAVEL_PATH} not existing"
  echo ""
# docker run --init -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     khs1994/php-fpm:7.2.5-alpine3.7 `
#     laravel $args

composer create-project --prefer-dist laravel/laravel=5.6.* "$LARAVEL_PATH"

}else{
  echo ""
  echo "${LARAVEL_PATH} existing"
  echo ""
}

if ($args -contains 'new' ){
  $global:LARAVEL_PATH=$args[1]

  echo "create new env file ..."

  cd ${LARAVEL_PATH}

  mv .env .env.backup

  cp $env:LNMP_PATH/app/.env* .

  echo "install laravel-ide-helper ..."

  composer require --dev barryvdh/laravel-ide-helper

  Write-Host "

Must EDIT ./${LARAVEL_PATH}/app/Providers/AppServiceProvider.php add this content



  public function register()
  {
      if ($this->app->environment() !== 'production') {
          $this->app->register(\Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider::class);
      }
      // ...
  }



Then exec

$ lnmp-php artisan ide-helper:generate
$ lnmp-php artisan ide-helper:meta
$ lnmp-php artisan optimize
"

  echo ".phpstorm.meta.php
_ide_helper.php" >> .gitignore

cd ..

}
