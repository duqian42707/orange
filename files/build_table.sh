#!/bin/bash

mysql_install_db --user=mysql

mysqld_safe &

sleep 3

mysql  -e "source /root/orange.sql;"

mysql  -e "grant all privileges on *.* to 'root'@'%' identified by '123456';"
mysql  -e "grant all privileges on *.* to 'root'@'localhost' identified by '123456';"


