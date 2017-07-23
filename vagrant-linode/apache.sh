#!/bin/bash
apt-get install apache2 -y
mv /etc/apache2/ports.conf /etc/apache2/ports.conf.backup
mv /etc/apache2/ports1.conf /etc/apache2/ports.conf
a2dissite 000-default.conf
a2ensite vhost.conf
service apache2 reload
