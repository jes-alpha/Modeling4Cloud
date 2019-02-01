#!/bin/bash
#!/bin/bash
CONFIG=$1
BACKENDADDR=$2

source $CONFIG

SEQNUMBER=1

echo "Setup hping TCP every $HPING_SECONDS_INTERVAL seconds starting from port $HPINGBASEPORT"
printf "\n Upload files: \n"

for a in "${vms[@]}"
do
	KEY=$(echo $a | awk '{print $1}')
	HOST=$(echo $a | awk '{print $2}')
	
	ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
		mkdir -p ~/Modeling4Cloud/utils/
		sudo apt-get update -qq
		sudo apt-get install expect -qq #needed for unbuffer
		sudo apt-get install hping3 -qq'"
		
	scp -r -i $KEY ./hping/enableHping.sh ubuntu@$HOST:~
	scp -r -i $KEY ./hping/registerHpingCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
	scp -r -i $KEY ./curlCsv.sh ubuntu@$HOST:~/Modeling4Cloud/utils/
done

printf "\n\n"
iCount=1
for i in "${vms[@]}"
do
	KEY=$(echo $i | awk '{print $1}')
	FROMHOST=$(echo $i | awk '{print $2}')
	FROMZONE=$(echo $i | awk '{print $3}')
	jCount=1
	for j in "${vms[@]}"
	do
		KEYTOHOST=$(echo $j | awk '{print $1}')
		TOHOST=$(echo $j | awk '{print $2}')
		TOZONE=$(echo $j | awk '{print $3}')
		PORT=$((HPINGBASEPORT+SEQNUMBER))
		
		if ! [ "$FROMZONE" = "$TOZONE" ]; then
			if [ "$HPING_BIDIRECTIONAL" -eq "1" -o "$jCount" -gt "$iCount" ]; then		
				echo "Setup Hping for $PROVIDER from $FROMHOST($FROMZONE) to $TOHOST($TOZONE) on port $PORT (SEQ_NUMBER:$SEQNUMBER)"
				ssh -i $KEY ubuntu@$FROMHOST bash -c "'./enableHping.sh $PROVIDER $FROMZONE $TOZONE $FROMHOST $TOHOST $SEQNUMBER $PORT $BACKENDADDR $HPING_SECONDS_INTERVAL'"
				printf "_____ COMPLETE _____ \n\n\n\n"
				
				SEQNUMBER=$(($SEQNUMBER+1))
			fi
		fi
		jCount=$(($jCount+1))
	done
	iCount=$(($iCount+1))
done



