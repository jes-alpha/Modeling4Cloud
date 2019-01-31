#!/bin/bash
echo __________________________ 10.0.0.7 __________________________
if pgrep mongo > /dev/null
then
	pgrep mongo | xargs sudo kill
fi
sudo rm -r -f /data/db-shard1
sudo rm -f ~/shardM4C*
sudo mkdir /data/db-shard1
sudo chown ubuntu /data/db-shard1
nohup mongod --shardsvr --replSet shardM4C1 --dbpath /data/db-shard1 --bind_ip 10.0.0.7 --port 27019 > ~/shardM4C1.out 2> ~/shardM4C1.err < /dev/null &

echo "Initializing shardM4C1..."
sleep 10
echo "rs.initiate({_id: \"shardM4C1\",members: [{_id: 0, host: \"10.0.0.7:27019\"}]})" | mongo --host 10.0.0.7 --port 27019
