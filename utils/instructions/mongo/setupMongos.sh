#!/bin/bash
#!/bin/bash
sudo rm -f ~/mongosM4C*
nohup mongos --configdb configM4C/10.0.0.18:27018 --bind_ip 0.0.0.0 --port 27017 > ~/mongosM4C.out 2> ~/mongosM4C.err < /dev/null &

echo " __________________________ Mongos setup  __________________________ "
sleep 10
mongo --port 27017 <<MONGO
sh.addShard("shardM4C1/10.0.0.7:27019")
sh.addShard("shardM4C2/10.0.0.4:27019")
sh.enableSharding("pings")
db.pings.ensureIndex({provider: 1, from_zone:1, to_zone:1, timestamp:1})
db.pings.dropIndex({provider:1})
sh.shardCollection("pings.pings", {provider: 1})
use admin
db.runCommand({split: "pings.pings", middle: {provider: "AZR"}})
db.runCommand({split: "pings.pings", middle: {provider: "GCP"}})
db.runCommand({split: "pings.pings", middle: {provider: "IBM"}})
sh.shardCollection("pings.bandwidthTests", {provider: 1})
db.runCommand({split: "pings.bandwidthTests", middle: {provider: "AZR"}})
db.runCommand({split: "pings.bandwidthTests", middle: {provider: "GCP"}})
db.runCommand({split: "pings.bandwidthTests", middle: {provider: "IBM"}})

MONGO
