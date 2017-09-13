FROM composer

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

RUN composer global require "laravel/installer"

RUN ln -sf /tmp/vendor/laravel/installer/laravel /usr/local/bin/
