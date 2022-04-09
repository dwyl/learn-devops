#!/bin/bash
echo "vagranttest" > /etc/hostname
hostname -F /etc/hostname
ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "$ip   $ip hostname" >> /etc/hosts
ln -sf /usr/share/zoneinfo/EST /etc/localtime
apt-get update && apt-get upgrade -y
