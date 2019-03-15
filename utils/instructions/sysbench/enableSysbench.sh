#!/bin/bash
PROVIDER=$1
HOST=$2
BACKEND_ADDR=$3
ID=$4


cline="~/Modeling4Cloud/utils/registerSysbenchCSV.sh $PROVIDER $HOST $ID> benchmark-$PROVIDER-$ID.out 2> benchmark-$PROVIDER-$ID.err < /dev/null &"

# Set up the test to run every 30 minutes, if crontb already exists it is updated
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '45,15 * * * *' "$cline" ) | crontab -
	echo "Added crontab for sysbench"
else
	echo "crontab job for sysbench already present"
fi

# Schedules the curlCsv script to run each day at midnight
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $ID $BACKEND_ADDR ~/csvBenchmark"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh # Makes the script runnable to be able to upload the benchmarking tests to the server

if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 0 * * *' "$cline" ) | crontab -  
	echo "Added crontab for curlCsv"
else
	echo "crontab job for curlCsv already present"
fi

echo "finished setting up enableSysbench"

echo first run
bash ~/Modeling4Cloud/utils/registerSysbenchCSV.sh $PROVIDER $HOST $ID> benchmark-$PROVIDER-$ID.out 2> benchmark-$PROVIDER-$ID.err < /dev/null &
echo enableSysbench first run fnished