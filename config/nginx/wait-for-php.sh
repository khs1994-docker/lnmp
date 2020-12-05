#!/bin/sh

until nc -z -w 1 php8 9000 || nc -z -w 1 127.0.0.1 9000 ; do
  echo "PHP8 is unavailable - sleeping"
  sleep 2
done

echo "PHP8 is up - executing command"

exec nginx -g 'daemon off;'
