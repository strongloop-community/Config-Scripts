#!/usr/bin/env sh


if [ $# -lt 1 ]; then
   echo "Usage: start-demo.sh <start|stop|update|clear>"
   exit
fi
if [ $1 = "start" ]; then
	echo "Killing Mongo DB ..."
	proc=`ps | grep mongod | grep -v grep | awk '{print $1}'`
	kill $proc
	rm -rf /data/db/edison*
	echo "Starting Mongo DB ..."
	mongod --storageEngine=mmapv1 2>$1 > mongo.log &
	sleep 5
	echo "Clearing out the Mongo Datastore ..."
	mongo mongo  --eval "db.dropDatabase()"
	sleep 5
	echo "Killing the StrongLoop application ..."
	proc=`ps | grep node | grep -v grep | awk '{print $1}'`
	kill $proc
    sleep 3
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
    echo "If you haven't yet, you should execute the following commands:"
    echo "    cd LSM9DS0"
    echo "    ./calibrate-acc-gyro"
    echo "    ./calibrate-mag"
    echo "    cd .."
    echo "to make sure your sensors are properly calibrated."
    cd ..
elif [ $1 = "clear" ]; then
	echo "Killing Mongo DB ..."
	proc=`ps | grep mongod | grep -v grep | awk '{print $1}'`
	kill $proc
	rm -rf /data/db/edison*
	echo "Starting Mongo DB ..."
	mongod --storageEngine=mmapv1 2>$1 > mongo.log &
	sleep 5
	echo "Clearing out the Mongo Datastore ..."
	mongo mongo  --eval "db.dropDatabase()"
	sleep 5
elif [ $1 = "stop" ]; then
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
else
    echo "Usage: demo-ctrl.sh <start|stop|update|clear>"
    echo "    start:  Start all the processes required for the demo"
    echo "            Any running processes will be killed first."
    echo "    stop:   Stop all processes associated with the demo."
    echo "    update: update all git repositories and re-build"
    echo "    clear:  Stop the MongoDB instance and clear out the data"
    echo "            and then re-start MongoDB."
fi

