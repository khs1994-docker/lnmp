#!/usr/bin/env python3

import os
import sys

import wsl

input_sudo = ''
input_version = ''

if len(sys.argv) == 3:
    input_version = sys.argv[1]
    input_sudo = sys.argv[2]
else:
    wsl.print_help_info('lnmp-wsl-builder-redis.py', 'Redis', '6.0.9')
    exit(0)

sudo_cmd = 'echo ' + input_sudo + ' | sudo -S '

ret = os.system(sudo_cmd + 'ls > /dev/null 2>&1')

if ret != 0:
    print('\nsudo password is not correct\n')
    exit(1)

'''

'''

redis_prefix='/usr/local/redis'

url = 'https://github.com/antirez/redis/archive/' + input_version + '.tar.gz'

wsl.download_src(url, input_version + '.tar.gz', 'redis-' + input_version)

os.system(sudo_cmd + 'apt update')

cmd = sudo_cmd + '''apt install -y gcc \
                                g++ \
                                libc6-dev \
                                make
'''

wsl.install_build_dep(cmd)

configure_cmd = 'echo "do nothing"'

wsl.builder('redis-' + input_version, configure_cmd, sudo_cmd)

wsl.test('redis-server -v')
