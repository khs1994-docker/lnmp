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
    wsl.print_help_info('lnmp_wsl_nginx_builder.py', 'NGINX', '1.13.11')
    exit(0)

sudo_cmd = 'echo ' + input_sudo + ' | sudo -S '

ret = os.system(sudo_cmd + 'ls > /dev/null 2>&1')

if ret != 0:
    print('\nsudo password is not correct\n')
    exit(1)

url = 'http://nginx.org/download/nginx-1.13.11.tar.gz'

wsl.download_src(url, input_version, 'nginx-1.13.11.tar.gz', 'nginx-1.13.11')

cmd = sudo_cmd + '''

'''

wsl.install_dep(cmd)

cmd = sudo_cmd + '''

'''

wsl.install_build_dep(cmd)

configure_cmd = '''

'''

bin_cmd = '''
'''

wsl.builder('nginx-1.13.11', configure_cmd, sudo_cmd, bin_cmd)
