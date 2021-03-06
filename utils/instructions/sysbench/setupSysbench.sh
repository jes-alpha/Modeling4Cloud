#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG
ID=0

for i in "${allVM[@]}"
do
    PROVIDER=$(echo $i | awk '{print $1}')
    KEY=$(echo $i | awk '{print $2}')
    HOST=$(echo $i | awk '{print $3}')
    ID=$((ID+1))
    echo "Setup Sysbench for $PROVIDER $HOST"
    ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	sudo apt-get update -qq
    sudo apt-get install sysbench -qq'"
    
    scp -r -i $KEY ./sysbench/enableSysbench.sh ubuntu@$HOST:~
    scp -r -i $KEY ./sysbench/registerSysbenchCSV.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
    scp -r -i $KEY ./curlCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/

    ssh -i $KEY ubuntu@$HOST bash -c "'
    chmod +x ~/enableSysbench.sh
    chmod +x ~/Modeling4Cloud/utils/registerSysbenchCSV.sh
    chmod +x ~/Modeling4Cloud/utils/setupSysbench.sh
    ./enableSysbench.sh $PROVIDER $HOST $BACKENDADDR $ID'"
    printf "_____ COMPLETE _____ \n\n\n\n"
done