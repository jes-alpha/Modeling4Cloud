CONFIG=$1
BACKENDADDR=$2

source $CONFIG

for i in "${qperfs[@]}"
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
	
	echo "Enable Qperf for $PROVIDER from $FROMHOST($FROMZONE) to $TOHOST($TOZONE) on port $PORT"
	#SETUP SERVER
	echo _____ SETUP SERVER _____
	ssh -o StrictHostKeyChecking=no -i $KEYTOHOST ubuntu@$TOHOST bash -c "'
	if pgrep -x qperf > /dev/null
	then
		echo qperf server already running
	else
		mkdir -p ~/Modeling4Cloud/utils/
		cd ~/Modeling4Cloud/utils/
		sudo apt-get install -y make gcc libc-dev -qq
		wget -q https://www.openfabrics.org/downloads/qperf/qperf-0.4.9.tar.gz
		tar xf qperf-0.4.9.tar.gz
		rm -f qperf-0.4.9.tar.gz
		cd qperf-0.4.9
		./configure
		make
		cd src
		nohup sudo ./qperf -lp $PORT > qperfserver.out 2> qperfserver.err < /dev/null &
	fi'"
	
	#SETUP CLIENT
	echo _____ SETUP CLIENT _____
	ssh -o StrictHostKeyChecking=no -i $KEYFROMHOST ubuntu@$FROMHOST bash -c "'
	mkdir -p ~/Modeling4Cloud/utils/
	cd ~/Modeling4Cloud/utils/
	sudo apt-get install -y make gcc libc-dev -qq
	wget https://www.openfabrics.org/downloads/qperf/qperf-0.4.9.tar.gz
	tar xvf qperf-0.4.9.tar.gz
	rm -f qperf-0.4.9.tar.gz
	cd qperf-0.4.9
	./configure
	make'"
	
	echo _____ STARTING _____
	scp -r -i $KEYFROMHOST ./qperf/enableQperf.sh ubuntu@$FROMHOST:~
	scp -r -i $KEYFROMHOST ./qperf/registerQperfCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	scp -r -i $KEYFROMHOST ./curlCsv.sh ubuntu@$FROMHOST:~/Modeling4Cloud/utils/
	ssh -i $KEYFROMHOST ubuntu@$FROMHOST bash -c "'./enableQperf.sh $PROVIDER $FROMZONE $TOZONE $TOHOST $PORT $SEQNUMBER $BACKENDADDR '"
	echo _____ COMPLETE _____
done



