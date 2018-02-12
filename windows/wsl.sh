#!/bin/bash

sudo redis-server /etc/redis/redis.conf

sudo mongod --fork --logpath=/var/run/mongodb/error.log

sudo memcached -d
