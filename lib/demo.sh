#!/bin/sh
systemctl start strong-pm
rm -rf /data/db/edison*
rm -rf /data/db/*lock*
/usr/local/bin/mongod --storageEngine=mmapv1 > /home/root/mongo.log &

# Uncomment the following 2 lines if you want the loopback app started via Node.
# leave commented to use the StrongLoop Process Manager
# sleep 5
# node /home/root/StrongLoop-IoT-Demo &
