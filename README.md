# [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Configuration Scripts

###These are some basic shell scripts to build, configure and run the [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Demo. 

####There's a small Chicken-and-egg problem with this:
There is a script included -- install-demo.sh -- that will completely configure and install everything on your Intel Edison for this demo. But Edison does not come with git installed by default so you can't really clone this project to your Edison and run it. The script will install git for you, but ...

#####Choices:
* Install git yourself on the Edison, then pull this project and proceed.
* Recommended: copy/pase the install.sh script to your Edison and run it to do everything for you.

###What the install script does:
* Updates the opkg repositories 
* Updates all the installed packages on your Edison
* Installs git
* Installs cmake -- in case it's not already there
* Updates Node.js to the most recent version that builds on the Edison. This update takes about 3 hours, so don't expect to do this all very quickly!
* Installs the Mongo DB C-Library for drivers
* Installs the MQTT C-Libraries
* Installs the Couchbase C-Library
* Installs Mongo DB
* Installs loopback
* Installs strong-pm from StrongLoop
* Installs [Sensor Reader](https://github.com/davidgs/LSM9DS0) to read the sensors
* Installs all these scripts


