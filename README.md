# [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Configuration Scripts

###These are some basic shell scripts to build, configure and run the [StrongLoop-IoT-Demo](https://github.com/davidgs/StrongLoop-IoT-Demo) Demo. 

####There's a small Chicken-and-egg problem with this:
There is a script included -- install-demo.sh -- that will completely configure and install everything on your Intel Edison for this demo. But Edison does not come with git installed by default so you can't really clone this project to your Edison and run it. The script will install git for you, but ...

#####Choices:
1) Install git yourself on the Edison, then pull this project and proceed.
2) Recommended: copy/pase the install.sh script to your Edison and run it to do everything for you.

###What the install script does:
1) Updates the opkg repositories 
2) Updates all the installed packages on your Edison
3) Installs git
4) Installs cmake -- in case it's not already there
5) Updates Node.js to the most recent version that builds on the Edison. This update takes about 3 hours, so don't expect to do this all very quickly!
6) Installs the Mongo DB C-Library for drivers
7) Installs the MQTT C-Libraries
8) Installs the Couchbase C-Library
9) Installs Mongo DB
10) Installs loopback
11) Installs strong-pm from StrongLoop
12) Installs [Sensor Reader](https://github.com/davidgs/LSM9DS0) to read the sensors
13) Installs all these scripts


