set -x

APP_PATH=/app/laravel-docker

APP_OWN=www-data:www-data

# laravel production cache
cd $APP_PATH
php artisan config:cache # config:clear
php artisan view:cache # view:clear
# 路由包含闭包无法缓存
# php artisan route:cache # route:clear

# php artisan migrate
# php artisan migrate --seed

cd /app

# nginx public
cp -a ${APP_PATH}/public/. ${APP_PATH}-public-volume

# chown
chown $APP_OWN ${APP_PATH}/storage/framework/views

chown $APP_OWN ${APP_PATH}/bootstrap/cache

# s6
cp -a $APP_PATH/.docker/s6/. /etc/services.d

chmod -R +x /etc/services.d

# exec
# exec $@
exec s6-svscan -t0 /etc/services.d
