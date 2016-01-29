#!/bin/sh

# Before running this script you should have already done the following:
# logged into your Intel Edison board and run configure_edison --wifi
# to set your device up on a network and configure_edison --password
# to set a root password on the device. 


# set up the ropsitories for Edison and make sure everything's up to date,
# then install git and cmake, if it's not already there
echo ""
echo "*********************************************"
echo "We're going to set up a whole bunch of stuff, and it's going to take a while ." 
echo "When we're done, your Edison will be ready to run the StrongLoop Demo without"
echo "any further alterations."
echo ""
echo "So let's get started!"
echo ""
echo "*********************************************"
sleep 10

echo "Setting up repositories ..."
echo ""
#echo "src all     http://iotdk.intel.com/repos/1.1/iotdk/all" >> /etc/opkg/base-feeds.conf
# echo "src x86 http://iotdk.intel.com/repos/1.1/iotdk/x86" >> /etc/opkg/base-feeds.conf
# echo "src i586    http://iotdk.intel.com/repos/1.1/iotdk/i586" >> /etc/opkg/base-feeds.conf
echo ""
echo "*********************************************"
echo "Updating Repositories ..."
echo ""
# opkg update
# opkg upgrade
echo ""
echo "*********************************************"
echo "Installing git ..."
# opkg install git
echo ""
echo "*********************************************"
echo "Installing cmake ..."
# opkg install cmake

# The version of node that comes with Edison is too old. The latest versions
# won't build, so use the last version that WILL
# This can take upwards of 2 hours to complete
# source is on my server since wget on Edison can't do https
echo ""
echo "*********************************************"
echo "Upgrading node ... (this will take a while!)"
sleep 5
# wget http://dragonflyiot.com/demoSoftware/node-v0.12.5.tar.gz
# tar xzf node-v0.12.5.tar.gz
# rm *.tar*
# cd node-v0.12.5
# ./configure
# make install
# cd ..
# rm -rf node*

# the root partition will fill up if we don't move /usr/local
# so move it to the /home partition
# this HAS to be done after node is built, not before, or building 
# Node.js will fail inexplicably
# mkdir /home/usr
# mv /usr/local /home/usr
# ln -s /home/usr/local /usr/local

# Build and install the MongoDB C-Libraries which are required
# source is on my server since wget on Edison can't do https
echo ""
echo "*********************************************"
echo "Installing MongoDB C Library ..."
wget http://dragonflyiot.com/demoSoftware/mongo-c-driver-1.3.1.tar.gz
tar xzf mongo-c-driver-1.3.1.tar.gz
rm mongo*.gz
cd mongo-c-driver-1.3.1/
./configure
make install
cd ..
rm -rf mongo*

# Build and install the MQTT libraries
# make install fails, so we do the install manually
echo ""
echo "*********************************************"
echo "Installing MQTT Libraries ... "
git clone https://git.eclipse.org/r/paho/org.eclipse.paho.mqtt.c
cd org.eclipse.paho.mqtt.c/
make
cp src/*.h /usr/local/include
cp build/output/*.so.1.0 /usr/local/lib
cd /usr/local/lib/
ln -s libpaho-mqtt3a.so.1.0 libpaho-mqtt3a.so.1
ln -s libpaho-mqtt3a.so.1 libpaho-mqtt3a.so
ln -s libpaho-mqtt3as.so.1.0 libpaho-mqtt3as.so.1
ln -s libpaho-mqtt3as.so.1 libpaho-mqtt3as.so
ln -s libpaho-mqtt3c.so.1.0 libpaho-mqtt3c.so.1
ln -s libpaho-mqtt3c.so.1 libpaho-mqtt3c.so
ln -s libpaho-mqtt3cs.so.1.0 libpaho-mqtt3cs.so.1
ln -s libpaho-mqtt3cs.so.1 libpaho-mqtt3cs.so
cd
rm -rf org.eclipse.paho.mqtt.c/

# install the couchbase libraries
# the configure script needs to be altered to work
echo ""
echo "*********************************************"
echo "Installing Couchbase Libraries ..."
git clone git://github.com/couchbase/libcouchbase.git
cd libcouchbase
sed -i '/RealBin/s/^/#/' configure.pl
sed -i '/RealBin/s/^/#/' cmake/configure

sed -i "166i my \$srcdir =\"/home/root/libcouchbase/\";" configure.pl
sed -i "166i my \$srcdir =\"/home/root/libcouchbase/\";" cmake/configure

mkdir build
cd build 
../cmake/configure --disable-plugins
make
make install
cd
rm -rf libcouchbase

# install mongodb for 32-bit linux
# source is on my server since wget on Edison can't do https
# the database is supposed to live in /data/db but again, we don't want to 
# fill the / partition, so link it to the /home partition
echo ""
echo "*********************************************"
echo "Installing MongoDB ..."
wget http://dragonflyiot.com/demoSoftware/mongodb-linux-i686-3.2.0.tgz
tar xzf mongodb-linux-i686-3.2.0.tgz
cp mongodb-linux-i686-3.2.0/bin/* /usr/local/bin
rm -rf mongodb*
rm ._mongodb-linux-i686-3.2.0
# mkdir /home/data
# mkdir /home/data/db
mkdir /data
mkdir /data/db
#ln -s /home/data/db /data/db

# update the library cache for all the stuff we just installed
echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

# install loopback
# npm installs will fail without some directory permission fixes
# so we make sure those are done first
cd
echo ""
echo "*********************************************"
echo "Installing loopback ..."
mkdir .npm
chmod -R a+rw .npm
chmod a+w .
npm install -g loopback

# this may not be strictly necessary, but ...
echo ""
echo "*********************************************"
echo "Installing sqlite3 ..."
npm install -g sqlite3

# Install Strong-pm, set it up as a system process and start it
echo ""
echo "*********************************************"
echo "Installing Strong-pm ..."
npm install -g strong-pm
sl-pm-install --systemd
systemctl start strong-pm

# Finally we grab the sensor reader code and build it.
echo ""
echo "*********************************************"
echo "Installing the Sensor Code ..."
git clone https://github.com/davidgs/LSM9DS0
cd LSM9DS0/
make

#We're all done! 
cd
echo ""
echo "*********************************************"
echo "You will need to start the Mongo DB by running mongod --storageEngine=mmapv1"
echo "the --storageEngine=mmapv1 is only required the FIRST time you start mongod"
echo "Then start the sensor collector as LSM9DS0/sensors --output mongo --dbhost localhost"
echo "If you plan to run the mongo db elsewhere, just change the argument of --dbhost"
