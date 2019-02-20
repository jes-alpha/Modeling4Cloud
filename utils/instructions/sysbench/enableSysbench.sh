#!/bin/bash
PROVIDER=$1
HOST=$2
BACKEND_ADDR=$3

cline="~/Modeling4Cloud/utils/registerSysbenchCsv.sh $PROVIDER $HOST > benchmark-$PROVIDER-$HOST.out 2> benchmark-$PROVIDER-$HOST.err </dev/null &"
chmod +x ~/Modeling4Cloud/utils/registerSysbenchCSV.sh # Makes the script runnable to be able to perform the benchmarking tests

# Set up the test to run every 30 minutes, if crontb already exists it is updated
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '45,15 0 * * *' "$cline" ) | crontab -  
	echo Added crontab for sysbencg
else
	echo crontab job for sysbench already present
fi

# Schedules the curlCsv script to run each day at midnight
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $BACKEND_ADDR ~/csvBenchmark"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh # Makes the script runnable to be able to upload the benchmarking tests to the server

if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 0 * * *' "$cline" ) | crontab -  
	echo Added crontab for curlCsv
else
	echo crontab job for curlCsv already present
fi

echo finished setting up enableSysbench