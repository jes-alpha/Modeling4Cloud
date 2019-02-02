#!/bin/bash

PROVIDER=$1 # TODO provider, number are the same in register and curl: find a method for unifying
NUMBER=$2
SERVER=$3
FOLDER=$4

if [ ! $FOLDER ]
	then
		FOLDER=~/csv
fi

YESTERDAY=$(date -d "yesterday 13:00" '+%Y-%m-%d') # OS X: $(date -v-1d +%F) Data di ieri in formato yyyy-mm-dd
TODAY=$(date +%Y-%m-%d) # Data di oggi in formato yyyy-mm-dd
#YESTERDAY=$TODAY # DEV
FILE=$FOLDER/$PROVIDER-$NUMBER-$YESTERDAY.csv

curl -F "data=@$FILE" $SERVER
sudo rm -f $FILE