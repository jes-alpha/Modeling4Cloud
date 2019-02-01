#!/bin/bash
#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG

SEQNUMBER=1

printf  "\n\nIperf settings: Test on port $PORT every $IPERF_HOUR_INTERVAL hours, for $DURATION seconds, with $PARALLEL parallel connections\n\n"

printf "\n Upload files: \n"
for a in "${vms[@]}"
do
	KEY=$(echo $a | awk '{print $1}')
	HOST=$(echo $a | awk '{print $2}')
	
	#SERVER
	scp -r -i $KEY ./iperf/serverIperf.sh ubuntu@$HOST:~
	
	#CLIENT
	ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
		mkdir -p ~/Modeling4Cloud/utils/
		sudo apt-get update -qq
		sudo apt-get install iperf3 -qq'"
	scp -r -i $KEY ./iperf/enableIperf.sh ubuntu@$HOST:~
	scp -r -i $KEY ./iperf/registerIperfCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
	scp -r -i $KEY ./curlCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
done
printf "\n\n"
iCount=1
for i in "${vms[@]}"
do
	KEYFROMHOST=$(echo $i | awk '{print $1}')
	FROMHOST=$(echo $i | awk '{print $2}')
	FROMZONE=$(echo $i | awk '{print $3}')
	jCount=1
	for j in "${vms[@]}"
	do
		KEYTOHOST=$(echo $j | awk '{print $1}')
		TOHOST=$(echo $j | awk '{print $2}')
		TOZONE=$(echo $j | awk '{print $3}')
		if ! [ "$FROMZONE" = "$TOZONE" ]; then
			if [ "$IPERF_BIDIRECTIONAL" -eq "1" -o "$jCount" -gt "$iCount" ]; then
				echo "Enable Iperf for $PROVIDER from $FROMHOST($FROMZONE) to $TOHOST($TOZONE) (SEQ_NUMBER:$SEQNUMBER)"
				#SETUP SERVER
				echo _____ SETUP SERVER _____
				ssh -o StrictHostKeyChecking=no -i $KEYTOHOST ubuntu@$TOHOST bash -c "'./serverIperf.sh $PORT'"
				
				#SETUP CLIENT
				echo _____ SETUP CLIENT _____
				ssh -i $KEYFROMHOST ubuntu@$FROMHOST bash -c "'./enableIperf.sh $PROVIDER $FROMZONE $TOZONE $FROMHOST $TOHOST $PORT $SEQNUMBER $BACKENDADDR $IPERF_HOUR_INTERVAL $DURATION $PARALLEL'"
				printf "_____ COMPLETE _____ \n\n\n\n"
				
				sleep $((DURATION*2)) # Delay to avoid overlap of different bandwidth tests
			fi
			SEQNUMBER=$(($SEQNUMBER+1))
		fi
		jCount=$(($jCount+1))
	done
	iCount=$(($iCount+1))
done
