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
    wsl.print_help_info('lnmp-wsl-builder-redis.py', 'Redis', '5.0-rc1')
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

wsl.download_src(url, '5.0-rc1.tar.gz', 'redis-5.0-rc1')

os.system(sudo_cmd + 'apt update')

cmd = sudo_cmd + '''apt install -y gcc \
                                g++ \
                                libc6-dev
'''

wsl.install_build_dep(cmd)

bin_cmd = 'echo "do nothing"'

configure_cmd = 'echo "do nothing"'

wsl.builder('redis-5.0-rc1', configure_cmd, sudo_cmd, bin_cmd)

test('redis-server -v')
