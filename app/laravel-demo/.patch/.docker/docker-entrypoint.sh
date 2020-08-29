set -x

APP_PATH=/app/laravel-docker

APP_OWN=www-data:www-data

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
