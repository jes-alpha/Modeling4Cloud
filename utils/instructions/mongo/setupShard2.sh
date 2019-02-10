#!/bin/bash
#!/bin/bash
echo __________________________ 10.0.0.4 __________________________
if pgrep mongo > /dev/null
then
	pgrep mongo | xargs sudo kill
fi
sudo rm -r -f /data/db-shard2
sudo rm -f ~/shardM4C*
sudo mkdir /data/db-shard2
sudo chown ubuntu /data/db-shard2
nohup mongod --shardsvr --replSet shardM4C2 --dbpath /data/db-shard2 --bind_ip 10.0.0.4 --port 27019 > ~/shardM4C2.out 2> ~/shardM4C2.err < /dev/null &

echo "Initializing shardM4C2..."
sleep 10
echo "rs.initiate({_id: \"shardM4C2\",members: [{_id: 0, host: \"10.0.0.4:27019\"}]})" | mongo --host 10.0.0.4 --port 27019
