PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMHOST=$4
TOHOST=$5
NUMBER=$6
PORT=$7
INTERVAL=$8

if [ ! $INTERVAL ]
	then
		INTERVAL=10
fi

if [ ! -d ~/csv ]; then
  mkdir ~/csv
fi

unbuffer sudo hping3 -S -p $PORT -i $INTERVAL $TOHOST |
(
COUNT=0

while read LINE; do
	echo $LINE
    if [ $COUNT != 0 ]
        then
			#linea hping: len=44 ip=35.180.31.118 ttl=47 DF id=0 sport=22 flags=SA seq=0 win=26883 rtt=9.4 msmv 
			#linea csv: AWS,eu-west-2c,eu-west-3c,18.130.223.116,35.180.92.154,247212,48,10.8,2018-07-29T13:31:11-00:00
            ICMPSEQ=$(echo $LINE | awk '{print $8}' | cut -d= -f2)
            TTL=$(echo $LINE | awk '{print $3}' | cut -d= -f2)
            TIME=$(echo $LINE | awk '{print $10}' | cut -d= -f2)
            TODAY=$(date +%Y-%m-%d)
            TIMESTAMP=$(date "+%Y-%m-%dT%H:%M:%S-00:00")
            FILE=~/csv/$PROVIDER-$NUMBER-$TODAY.csv

            if ! [ -s $FILE ]
                then
                    printf "provider,from_zone,to_zone,from_host,to_host,icmp_seq,ttl,time,timestamp\n" >> $FILE
            fi
			
			
            printf "$PROVIDER,$FROMZONE,$TOZONE,$FROMHOST,$TOHOST,$ICMPSEQ,$TTL,$TIME,$TIMESTAMP\n" >> $FILE
            # curl -d "provider=$PROVIDER&fromZone=$FROMZONE&toZone=$TOZONE&fromHost=$FROMHOST&toHost=$TOHOST&icmp_seq=$ICMPSEQ&ttl=$TTL&time=$TIME" -X POST $SERVER
    fi
    COUNT=$((COUNT + 1))
done
)

# Ping normale: 68 bytes prima riga, 101 bytes altre righe ~ 6,2KB / min. 8,928 MB / day. ~ 267,840 MB / month ~ 3,214 GB / year
#Hping: Durata ping TCP = 111ms, Ping ogni secondo, 8 pacchetti ogni ping
# Hping3(Rete con 1 ping al secondo): 489 byte ogni ping ~ 29340 B/min. | ~1719 KB/hour | ~40 MB/day
# Hping3(File csv): 7.8 MB/day
