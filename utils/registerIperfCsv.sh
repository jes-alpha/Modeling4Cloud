#!/bin/bash
PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMHOST=$4
TOHOST=$5
PORT=$6 #-p
NUMBER=$7
HOUR_INTERVAL=$8
DURATION=$9
PARALLEL=${10}

echo Started with params: $PROVIDER $FROMZONE $TOZONE $FROMHOST $TOHOST $PORT $NUMBER $HOUR_INTERVAL $DURATION $PARALLEL

if [ ! -d ~/csvIperf ]; then
  mkdir ~/csvIperf
fi

echo "~/Modeling4Cloud/utils/registerIperfCsv.sh $PROVIDER $FROMZONE $TOZONE $FROMHOST $TOHOST $PORT $NUMBER $HOUR_INTERVAL $DURATION $PARALLEL $INTERVAL > iperf-$FROMZONE-$TOZONE-$NUMBER.out 2> iperf-$FROMZONE-$TOZONE-$NUMBER.err < /dev/null" | at now + $HOUR_INTERVAL hour 2> /dev/null

RESULT=$(sudo iperf3 -c $TOHOST -p $PORT -t $DURATION -P $PARALLEL -i $DURATION -f M)
#echo "$RESULT" #dev

SENDER=$(echo "$RESULT" | tail -n 4 | head -1)
RECEIVER=$(echo "$RESULT" | tail -n 3 | head -1)

TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date "+%Y-%m-%dT%H:%M:%S-00:00")

if [ $PARALLEL -eq 1 ];then
	BANDWIDTH=$(echo $RECEIVER | awk '{print $7}' | cut -d= -f2)
	TRANSFER=$(echo $SENDER | awk '{print $5}' | cut -d= -f2)
	TRANSFERUNIT=$(echo $SENDER | awk '{print $6}' | cut -d= -f2)
	RETRANSMISSIONS=$(echo $SENDER | awk '{print $9}' | cut -d= -f2)
else
	BANDWIDTH=$(echo $RECEIVER | awk '{print $6}' | cut -d= -f2)
	TRANSFER=$(echo $SENDER | awk '{print $4}' | cut -d= -f2)
	TRANSFERUNIT=$(echo $SENDER | awk '{print $5}' | cut -d= -f2)
	RETRANSMISSIONS=$(echo $SENDER | awk '{print $8}' | cut -d= -f2)
fi

if [ $TRANSFERUNIT = "KBytes" -o $TRANSFERUNIT = "Bytes" ]; then
	TRANSFER=1
fi

FILE=~/csvIperf/$PROVIDER-$NUMBER-$TODAY.csv

if ! [ -s $FILE ]
	then
		printf "provider,from_zone,to_zone,from_host,to_host,timestamp,bandwidth,duration,parallel,transfer,retransmissions\n" >> $FILE
fi


printf "$PROVIDER,$FROMZONE,$TOZONE,$FROMHOST,$TOHOST,$TIMESTAMP,$BANDWIDTH,$DURATION,$PARALLEL,$TRANSFER,$RETRANSMISSIONS\n" >> $FILE
# curl -d "provider=$PROVIDER&fromZone=$FROMZONE&toZone=$TOZONE&fromHost=$FROMHOST&toHost=$TOHOST&icmp_seq=$ICMPSEQ&ttl=$TTL&time=$TIME" -X POST $SERVER

#Duration 3 parallel 1 interval 3 = network usage 372 MB
#Duration 1 parallel 1 interval 1 = network usage 122 MB
