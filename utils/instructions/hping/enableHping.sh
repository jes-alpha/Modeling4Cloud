#!/bin/bash
PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMIP=$4
TOIP=$5
SEQ_NUMBER=$6
PORT=$7
BACKEND_ADDR=$8
INTERVAL=$9

#Download da github
#rm -r -f ~/Modeling4Cloud 
#git clone https://github.com/danipisca07/Modeling4Cloud.git


#Avvia pinging
chmod +x ~/Modeling4Cloud/utils/registerHpingCsv.sh #Rende eseguibile lo script per il pinging
nohup ~/Modeling4Cloud/utils/registerHpingCsv.sh $PROVIDER $FROMZONE $TOZONE $FROMIP $TOIP $SEQ_NUMBER $PORT $INTERVAL > $FROMZONE-$TOZONE-$SEQ_NUMBER.out 2> $FROMZONE-$TOZONE-$SEQ_NUMBER.err < /dev/null &
#~/Modeling4Cloud/utils/registerHpingCsv.sh $PROVIDER $FROMZONE $TOZONE $TOIP $SEQ_NUMBER


#Schedula lo script per il caricamento al backend dei ping ogni mezzanotte
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $SEQ_NUMBER $BACKEND_ADDR ~/csv"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh #Rende eseguibile lo script per il caricamento dei ping eseguiti
#crontab -r #Rimuove tutti i crontab
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 0 * * *' "$cline" ) | crontab - 
	echo Added hpingCurl crontab
else
	echo hpingCurl crontab already setup
fi