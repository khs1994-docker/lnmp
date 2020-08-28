set -x

APP_PATH=/app/laravel-docker

APP_OWN=www-data:www-data

cp -a ${APP_PATH}/public/. ${APP_PATH}-public-volume

chown $APP_OWN ${APP_PATH}/storage/framework/views

chown $APP_OWN ${APP_PATH}/bootstrap/cache

exec $@
