PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMHOST="$(curl ipinfo.io/ip)"
TOHOST=$4
NUMBER=$5

if ! [ -d ~/csv ]; then
  mkdir ~/csv
fi

ping $TOHOST |
(
COUNT=0

while read LINE; do
    if [ $COUNT != 0 ]
        then
            ICMPSEQ=$(echo $LINE | awk '{print $5}' | cut -d= -f2)
            TTL=$(echo $LINE | awk '{print $6}' | cut -d= -f2)
            TIME=$(echo $LINE | awk '{print $7}' | cut -d= -f2)
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
    COUNT=$[ COUNT + 1 ]
done
)

# 68 bytes prima riga, 101 bytes altre righe ~ 6,2KB / min. 8,928 MB / day. ~ 267,840 MB / month ~ 3,214 GB / year