#!/bin/bash
echo __________________________ 10.0.0.18 __________________________
if pgrep mongo > /dev/null
then
	pgrep mongo | xargs sudo kill
fi
sudo rm -r -f /data/configdb
sudo rm -f ~/configM4C*
sudo mkdir /data/configdb
sudo chown ubuntu /data/configdb
nohup mongod --configsvr --replSet configM4C --dbpath /data/configdb --bind_ip 10.0.0.18 --port 27018 > ~/configM4C.out 2> ~/configM4C.err < /dev/null &

echo "Initializing configM4C..."
sleep 10
echo "rs.initiate({_id:\"configM4C\",configsvr: true,members: [{_id: 0, host: \"10.0.0.18:27018\"},]})" | mongo --host 10.0.0.18 --port 27018
