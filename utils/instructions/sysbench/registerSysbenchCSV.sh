#!/bin/bash
PROVIDER=$1
HOST=$2

if [ ! -d ~/csvBenchmark ]; then
  mkdir ~/csvBenchmark
fi

#chrontab is done at *:45 and *:15 thus it is extremley improbable that the tests are not run in the same day.
TODAY=$(date +%Y-%m-%d)
FILE=~/csvBenchmark/$PROVIDER-$HOST-$TODAY.csv

if ! [ -s "$FILE" ]
	then
		printf "provider, ip, timestamp, threads, total time, total events, cpus\n" >> "$FILE"
fi

for each in 1 2 4 8 16 32 64
do
# Benchmark result
BMRESULT=$(sysbench cpu --cpu-max-prime=20000 --threads=$each run)
#echo $BMRESULT

THREADS=$each
TOTTIME=$(echo "$BMRESULT" | grep "total time:" | awk '{print $3}' | cut -d s -f1)
TOTEVENTS=$(echo "$BMRESULT" | grep "total number of events:" | awk '{print $5}' )
#MAXPRIME=$(echo "$BMRESULT" | grep "Prime numbers limit:" | awk '{print$4}' )

# Hardware result
# lscpu --parse includes  4 lines with comments starting with '#''
NCPU=$(lscpu --parse | grep -v "#" | wc -l)

TIMESTAMP=$(date "+%Y-%m-%dT%H:%M:%S-00:00")

printf "$PROVIDER, $HOST, $TIMESTAMP, $THREADS, $TOTTIME, $TOTEVENTS, $NCPU\n" >> $FILE
done

echo finished registerSysbencCSV