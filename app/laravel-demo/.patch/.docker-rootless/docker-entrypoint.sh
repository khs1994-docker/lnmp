set -x

APP_PATH=/app/laravel-docker

APP_OWN=www-data:www-data

# laravel production cache
cd $APP_PATH
php artisan config:cache
# 提前将 $APP_PATH/storage/framework/views 挂载卷用户设为 www-data:www-data
php artisan view:cache
# php artisan route:cache

# php artisan migrate
# php artisan migrate --seed

cd /app

# nginx public
# 提前将 nginx public 挂载卷用户设为 www-data:www-data
cp -af ${APP_PATH}/public/. ${APP_PATH}-public-volume

# exec
# exec $@
exec s6-svscan -t0 $APP_PATH/.docker-rootless/s6
