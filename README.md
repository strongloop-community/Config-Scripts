# [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Configuration Scripts

###These are some basic shell scripts to build, configure and run the [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Demo. 

####There's a small Chicken-and-egg problem with this:
There is one configuration and control script included -- demo-ctrl.sh -- that will completely configure and install everything on your Intel Edison for this demo, start/stop all the required processes, clean out the Mongo Database, and update all the repositories. But Edison does not come with git installed by default so you can't really clone this project to your Edison and run it. The script will install git for you, but ...

###Installation:
* Install git yourself on the Edison, then pull this project and proceed.
<code>
    echo "src all     http://iotdk.intel.com/repos/1.1/iotdk/all" >> /etc/opkg/base-feeds.conf
    echo "src x86 http://iotdk.intel.com/repos/1.1/iotdk/x86" >> /etc/opkg/base-feeds.conf
    echo "src i586    http://iotdk.intel.com/repos/1.1/iotdk/i586" >> /etc/opkg/base-feeds.conf
    opkg update
    opkg upgrade
    opkg install git
</code>

###What the  script does:
Options:   
####Install:   
* Updates the opkg repositories.   
* Updates all the installed packages on your Edison.   
* Installs cmake -- in case it's not already there.   
* Updates Node.js to the most recent version that builds on the Edison. This update takes about 3 hours, so don't expect to do this all very quickly!.   
* Installs the Mongo DB C-Library for drivers.   
* Installs the MQTT C-Libraries.   
* Installs the Couchbase C-Library.   
* Installs Mongo DB.   
* Installs loopback.   
* Installs strong-pm from StrongLoop.   
* Installs [Sensor Reader](https://github.com/davidgs/LSM9DS0) to read the sensors.   
* Installs all the scripts for auto-start, etc. scripts.   

####Start:   
* Makes sure none of the processes are running already.   
* Kills mongod.   
* Wipes out the Mongo database files.   
* Starts mongod.   
* Kills off the loopback application.   
* Starts the loopback application.   
* starts the sensor-reader process.   

####Stop:   
* Kills mongod.   
* Kills the LoopBack Application.   
* Kills the sensor reader process.   

####Update:  
* Executes a git pull on all the repositories.  
* Recompiles the sensor-reader.  
* npm installs the LoopBack application.  

####Clear
* Kills mongod
* Clears out the mongo datastore
* Restarts mongod


