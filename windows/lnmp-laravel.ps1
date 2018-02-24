if ("$args[0]" = 'new'){
  if ("$args[1].Count" = 0 ){
    exit 1
  }
}

docker run -it --rm --mount type=bind,src=$PWD,target=/app --mount src=lnmp_composer_cache-data,target=/tmp/cache khs1994/php-fpm:7.2.2-alpine3.7 laravel "$@"

if ("$args[0]" = 'new'){
  LARAVEL_PATH="$args[1]"

  echo -e "\n\033[32mINFO\033[0m  create new env file ..."

  cd ${LARAVEL_PATH}

  mv .env .env.backup

  cp $LNMP_PATH/app/.env* .

  echo -e "\n\033[32mINFO\033[0m  change Redis config ..."

  bash sed -i 's#predis#phpredis#g' config/database.php

  echo -e "\n\033[32mINFO\033[0m  install laravel-ide-helper ..."

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

  Write-Host ".phpstorm.meta.php
  _ide_helper.php" >> .gitignore

cd ..

}
