echo "==> create new env file ..."

if (Test-Path .env){
  mv .env .env.backup
}

cp $env:LNMP_PATH/app/.env* .

cp $env:LNMP_PATH/app/demo/.editorconfig .
cp $env:LNMP_PATH/app/demo/.php_cs .

echo "==> install laravel-ide-helper ..."

composer require --dev barryvdh/laravel-ide-helper

Write-Host '

Must EDIT app/Providers/AppServiceProvider.php add this content



public function register()
{
    if ($this->app->environment() !== "production") {
        $this->app->register(\Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider::class);
    }
    // ...
}



Then exec

$ lnmp-php artisan ide-helper:eloquent
$ lnmp-php artisan ide-helper:generate
$ lnmp-php artisan ide-helper:meta
$ lnmp-php artisan ide-helper:models
'

echo ".phpstorm.meta.php
_ide_helper.php

.php_cs.cache
" >> .gitignore
