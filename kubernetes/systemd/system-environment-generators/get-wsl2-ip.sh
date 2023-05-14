#!/bin/sh
WSL2_IP=$(ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

echo WSL2_IP=$WSL2_IP
