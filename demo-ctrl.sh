#!/usr/bin/env sh


if [ $# -lt 1 ]; then
   echo "Usage: start-demo.sh <start|stop|update>"
   exit
fi
if [ $1 = "start" ]; then
	rm -rf /data/db/edison*
	echo "Starting Mongo DB ..."
	mongod --storageEngine=mmapv1 2>$1 > mongo.log &
	sleep 5
	echo "Clearing out the Mongo Datastore ..."
	mongo mongo  --eval "db.dropDatabase()"
	sleep 5
	
	echo "Starting Strongloop application ..."
	systemctl start strong-pm
	cd StrongLoop-IoT-Demo
	node .  2>$1 > /dev/null &
	sleep 15
	echo "Starting the sensor logger ... "
	sleep 3
	cd ..
	cd LSM9DS0
	./sensors --output json --dbhost localhost &
	cd ..
	ip_addr=`ifconfig wlan0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'` 
	echo "Connect to your application at http://$ip_addr:3000/"
elif [ $1 = "update" ]; then
    cd StrongLoop-IoT-Demo
    git pull
    npm install
    cd ../LSM9DS0
    git pull
    make clean
    make
    cd ..
else
	echo "Killing sensor logger ..."
	proc=`ps | grep sensors | grep -v grep | awk '{print $1}'`
	kill $proc
	echo "Killing mongod ..."
	proc=`ps | grep mongod | grep -v grep | awk '{print $1}'`
	kill $proc
	echo "Stopping strong-pm ..."
	systemctl stop strong-pm
	echo "Killing the application ..."
	proc=`ps | grep node | grep -v grep | awk '{print $1}'`
	kill $proc
fi

