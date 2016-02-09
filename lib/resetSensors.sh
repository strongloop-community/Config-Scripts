#!/usr/bin/env sh

pid=`ps | grep sensors | grep -v grep | awk '{print $1}'`
if [ $pid ]; then
   kill $pid
fi
echo "restarating Sensors ... "
cd /home/root/LSM9DS0
./sensors --output json --dbhost localhost &
