#!/bin/bash
set -e

usermod -d /var/lib/mysql/ mysql
echo `service mysql status`

echo '1. 启动 MySQL ...'

service mysql start
sleep 2
echo `service mysql status`

echo '2. 开始导入数据'
# mysql < ./niuktok.sql
echo '导入数据完毕 ...'

sleep 2

echo '3. 开始修改密码'
mysql < ./auth.sql
echo '修改密码完毕 ...'

echo `service mysql status`

tail -f /dev/null
