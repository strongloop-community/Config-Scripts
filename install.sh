#!/usr/bin/env sh

echo "Making everything start on device boot ..."
if [ !-d /etc/init.d ]; then
    mkdir /etc/init.d
fi
cp demo.sh /etc/init.d
chmod +x /etc/init.d/demo.sh
update-rc.d demo.sh defaults
echo ""
echo "Updating the built-in webserver ... "
cp edison-config-server.js /usr/lib/edison_config_tools
cp resetSensors.sh /usr/lib/edison_config_tools
chmod +x /usr/lib/edison_config_tools/resetSensors.sh
cp findmongo.sh /usr/lib/edison_config_tools
chmod +x /usr/lib/edison_config_tools/findmongo.sh
kill `ps | grep edison-config-server | grep node | awk '{print $1}'`
echo "All done!"