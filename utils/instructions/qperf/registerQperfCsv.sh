PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMHOST="$(curl ipinfo.io/ip &> /dev/null)"
TOHOST=$4
PORT=$5 #-p
NUMBER=$6
DURATION=$7 #-t


if [ ! $PORT ]
	then
		PORT=8080
		echo using port $PORT
fi
if [ ! $DURATION ]
	then
		DURATION=1
		echo using duration $DURATION sec
fi

if [ ! -d ~/csvQperf ]; then
  mkdir ~/csvQperf
fi

RESULTS=$(~/qperf/qperf-0.4.9/src/qperf -v -vvc -vvs -vvt -vvu -lp $PORT -t $DURATION $TOHOST tcp_bw)
TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date "+%Y-%m-%dT%H:%M:%S-00:00")
BANDWIDTH=$(echo "$RESULTS" | grep " bw " | awk '{print $3}' | cut -d= -f2)
DURATION=$(echo "$RESULTS" | grep " time " | head -1 | awk '{print $3}' | cut -d= -f2)
PARALLEL=1
TRANSFER=$(echo "$RESULTS" | grep " send_bytes " | awk '{print $3}' | cut -d= -f2)
SENTMSG=$(echo "$RESULTS" | grep " send_msgs " | awk '{print $3}' | sed 's/,//' | cut -d= -f2)
RECVMSG=$(echo "$RESULTS" | grep " recv_msgs " | awk '{print $3}' | sed 's/,//' | cut -d= -f2)
RETRANSMISSIONS=$(expr $SENTMSG - $RECVMSG)
FILE=~/csvQperf/$PROVIDER-$NUMBER-$TODAY.csv

if ! [ -s $FILE ]
	then
		printf "provider,from_zone,to_zone,from_host,to_host,timestamp,bandwidth,duration,parallel,transfer,retransmissions\n" >> $FILE
fi


printf "$PROVIDER,$FROMZONE,$TOZONE,$FROMHOST,$TOHOST,$TIMESTAMP,$BANDWIDTH,$DURATION,$PARALLEL,$TRANSFER,$RETRANSMISSIONS\n" >> $FILE
# curl -d "provider=$PROVIDER&fromZone=$FROMZONE&toZone=$TOZONE&fromHost=$FROMHOST&toHost=$TOHOST&icmp_seq=$ICMPSEQ&ttl=$TTL&time=$TIME" -X POST $SERVER



