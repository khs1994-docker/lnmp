#!/bin/sh
WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | cut -d ' ' -f 2)

echo WINDOWS_IP=$WINDOWS_IP
