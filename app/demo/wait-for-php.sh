#!/bin/sh

until nc -z -w 1 php7 9000 || nc -z -w 1 127.0.0.1 9000 ; do
  echo "PHP7 is unavailable - sleeping"
  sleep 1
done

echo "PHP7 is up - executing command"

exec nginx -g 'daemon off;'
