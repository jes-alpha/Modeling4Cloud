#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG

for ip in "${allVM[@]}"
do
    PROVIDER=$(echo $i | awk '{print $1}')
    KEY=$(echo $i | awk '{print $2}')
    HOST=$(echo $i | awk '{print $3}')
    PORT=22

    echo "Setup Sysbench for $PROVIDER from $HOST on port $PORT"
    ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$FROMHOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	sudo apt-get update -qq
	sudo apt-get install expect -qq #needed for unbuffer
    sudo apt-get install sysbench -qq'"
    scp -r -i $KEY ./sysbench/enableSysbench.sh ubuntu@$FROMHOST:~
    scp -r -i $KEY ./sysbench/registerSysbenchCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
    scp -r -i $KEY ./curlCsv.sh ubuntu@HOST:~/Modeling4Cloud/utils/
    ssh -i $KEY ubuntu@$FROMHOST bash -c "'./enableSysbench.sh $PROVIDER $HOST $PORT $BACKENDADDR '"
    printf "_____ COMPLETE _____ \n\n\n\n"
done