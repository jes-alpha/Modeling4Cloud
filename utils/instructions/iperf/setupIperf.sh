#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG

for i in "${iperfs[@]}"
do
	PROVIDER=$(echo $i | awk '{print $1}')
	KEYFROMHOST=$(echo $i | awk '{print $2}')
	FROMHOST=$(echo $i | awk '{print $3}')
	KEYTOHOST=$(echo $i | awk '{print $4}')
	TOHOST=$(echo $i | awk '{print $5}')
	FROMZONE=$(echo $i | awk '{print $6}')
	TOZONE=$(echo $i | awk '{print $7}')
	PORT=$(echo $i | awk '{print $8}')
	SEQNUMBER=$(echo $i | awk '{print $9}') #Utilizzare un contatore incrementale?
	HOUR_INTERVAL=$(echo $i | awk '{print $10}')
	DURATION=$(echo $i | awk '{print $11}')
	PARALLEL=$(echo $i | awk '{print $12}')
	
	echo "Enable Iperf for $PROVIDER from $FROMHOST($FROMZONE) to $TOHOST($TOZONE) on port $PORT every $HOUR_INTERVAL hours cfg: $DURATION-$PARALLEL"
	#SETUP SERVER
	echo _____ SETUP SERVER _____
	scp -r -i $KEYTOHOST ./iperf/serverIperf.sh ubuntu@$TOHOST:~
	ssh -i $KEYTOHOST ubuntu@$TOHOST bash -c "'./serverIperf.sh $PORT'"
	#ssh -i $KEYTOHOST ubuntu@$TOHOST bash -c "'
	#sudo apt-get update -qq
	#sudo apt-get install expect -qq
	#sudo apt-get install iperf3 -qq
	#if pgrep -x iperf3 > /dev/null
	#then
	#	echo iperf3 server already running
	#else
	#	nohup sudo iperf3 -s -p $PORT -D > iperfserver.out 2> iperfserver.err < /dev/null &
	#fi
	#'"
	
	#SETUP CLIENT
	echo _____ SETUP CLIENT _____
	ssh -o StrictHostKeyChecking=no -i $KEYFROMHOST ubuntu@$FROMHOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	sudo apt-get update -qq
	#sudo apt-get install expect -qq
	sudo apt-get install iperf3 -qq'"
	
	scp -r -i $KEYFROMHOST ./iperf/enableIperf.sh ubuntu@$FROMHOST:~
	scp -r -i $KEYFROMHOST ./iperf/registerIperfCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	scp -r -i $KEYFROMHOST ./curlCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	ssh -i $KEYFROMHOST ubuntu@$FROMHOST bash -c "'./enableIperf.sh $PROVIDER $FROMZONE $TOZONE $FROMHOST $TOHOST $PORT $SEQNUMBER $BACKENDADDR $HOUR_INTERVAL $DURATION $PARALLEL'"
	printf "_____ COMPLETE _____ \n\n\n\n"
	sleep $((DURATION*2)) # Delay to avoid overlap of different bandwidth tests
done
