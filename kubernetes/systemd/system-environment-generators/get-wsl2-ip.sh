#!/bin/sh
WSL2_IP=$(ip addr | grep eth0 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

if [ -n "$WSL2_IP" ];then echo WSL2_IP=$WSL2_IP; exit 0; fi

WSL2_IP=$(ip addr | grep eth1 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

if [ -n "$WSL2_IP" ];then echo WSL2_IP=$WSL2_IP; exit 0; fi

WSL2_IP=$(ip addr | grep eth2 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

if [ -n "$WSL2_IP" ];then echo WSL2_IP=$WSL2_IP; exit 0; fi

WSL2_IP=$(ip addr | grep eth3 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

if [ -n "$WSL2_IP" ];then echo WSL2_IP=$WSL2_IP; exit 0; fi

WSL2_IP=$(ip addr | grep eth4 | grep inet | cut -d ' ' -f 6 | cut -d '/' -f 1)

echo WSL2_IP=$WSL2_IP
