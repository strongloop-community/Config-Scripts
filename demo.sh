#!/bin/sh
systemctl start strong-pm
rm -rf /data/db/edison*
rm -rf /data/db/*lock*
/usr/local/bin/mongod --storageEngine=mmapv1 > /home/root/mongo.log &
sleep 5
node /home/root/StrongLoop-IoT-Demo &
