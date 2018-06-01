#!/usr/bin/env bash

set -ex

/docker-entrypoint.composer.sh "$@"

tar -zcvf ${LARAVEL_PATH}.tar.gz ${LARAVEL_PATH}

cp /tmp/${LARAVEL_PATH}.tar.gz /app
