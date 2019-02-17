#!/bin/bash
PROVIDER=$1
HOST=$2

#echo Started with params: 

if [ ! -d ~/csvBandwidth ]; then
  mkdir ~/csvBandwidth
fi

echo "~/Modeling4Cloud/utils/registerBandwidthCsv.sh $PROVIDER $HOST > benchmark-$PROVIDER-$HOST.out 2> benchmark-$PROVIDER-$HOST.err < /dev/null"> /dev/null
#todo
RESULT=$(sudo iperf3 -c $TOHOST -p $PORT -t $DURATION -P $PARALLEL -i $DURATION -f M)
#echo "$RESULT" #dev

SENDER=$(echo "$RESULT" | tail -n 4 | head -1)
RECEIVER=$(echo "$RESULT" | tail -n 3 | head -1)

TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date "+%Y-%m-%dT%H:%M:%S-00:00")



FILE=~/csvBandwidth/$PROVIDER-$TODAY.csv

if ! [ -s $FILE ]
	then
		printf "provider, ip, timestamp, threads, primeNumbers, eventsPerSec, totalEvents, time\n" >> $FILE
fi


printf "$PROVIDER,$FROMZONE,$TOZONE,$FROMHOST,$TOHOST,$TIMESTAMP,$BANDWIDTH,$DURATION,$PARALLEL,$TRANSFER,$RETRANSMISSIONS\n" >> $FILE
# curl -d "provider=$PROVIDER&fromZone=$FROMZONE&toZone=$TOZONE&fromHost=$FROMHOST&toHost=$TOHOST&icmp_seq=$ICMPSEQ&ttl=$TTL&time=$TIME" -X POST $SERVER

#Duration 3 parallel 1 interval 3 = network usage 372 MB
#Duration 1 parallel 1 interval 1 = network usage 122 MB
