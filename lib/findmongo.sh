#!/usr/bin/env sh

pid=`ps | grep mongod | grep -v grep | awk '{print $1}'`
if [ $pid ]; then
   kill $pid
fi
rm -rf /data/db/edison*
echo "restarating Mongod ... "
/usr/local/bin/mongod --storageEngine=mmapv1 > /home/root/mongo.log &


