if (!($args -contains 'new')){
  exit 1
}

if ($args.Count -lt 2 ){
    exit 1
}

$global:LARAVEL_PATH=$args[1]

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache --entrypoint /docker-entrypoint.composer.sh khs1994/php-fpm:7.2.3-alpine3.7 composer create-project --prefer-dist laravel/laravel=5.5.* "$LARAVEL_PATH"

echo "create new env file ..."

  cd ${LARAVEL_PATH}

  mv .env .env.backup

  cp $env:LNMP_PATH/app/.env* .

  echo "install laravel-ide-helper ..."

  lnmp-composer require --dev barryvdh/laravel-ide-helper

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
