if (!($args -contains 'new')){
  exit 1
}

if ($args.Count -lt 2 ){
    exit 1
}

$global:LARAVEL_PATH=$args[1]

if (!(Test-Path ${LARAVEL_PATH})){
  echo ""
  echo "${LARAVEL_PATH} not existing"
  echo ""
# docker run -it --rm `
#     --mount type=bind,src=$PWD,target=/app `
#     --mount src=lnmp_composer_cache-data,target=/tmp/cache `
#     --mount type=bind,src=$env:LNMP_PATH/windows/docker-entrypoint.laravel.sh,target=/docker-entrypoint.laravel.sh `
#     --entrypoint /docker-entrypoint.laravel.sh `
#     --workdir /tmp `
#     -e LARAVEL_PATH=${LARAVEL_PATH} `
#     khs1994/php-fpm:7.2.4-alpine3.7 `
    composer create-project --prefer-dist laravel/laravel=5.5.* "$LARAVEL_PATH"

# tar -zxvf .\${LARAVEL_PATH}.tar.gz
}else{
  echo ""
  echo "${LARAVEL_PATH} existing"
  echo ""
}

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
