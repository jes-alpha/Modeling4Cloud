#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG

for ip in "${allVM[@]}"
do
    PROVIDER=$(echo $i | awk '{print $1}')
    KEY=$(echo $i | awk '{print $2}')
    HOST=$(echo $i | awk '{print $3}')
    INTERVAL = 30 #run test eery 30 min
    
    echo "Setup Sysbench for $PROVIDER from $HOST"
    ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	sudo apt-get update -qq
    sudo apt-get install sysbench -qq'"
    scp -r -i $KEY ./sysbench/enableSysbench.sh ubuntu@$HOST:~
    scp -r -i $KEY ./sysbench/registerSysbenchCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
    scp -r -i $KEY ./sysbench/runCpuTest.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
    ssh -i $KEY ubuntu@$HOST bash -c "'./enableSysbench.sh $PROVIDER $HOST $BACKENDADDR $INTERVAL '"
    printf "_____ COMPLETE _____ \n\n\n\n"
done