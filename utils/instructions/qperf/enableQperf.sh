#!/bin/bash
PROVIDER=$1
FROMZONE=$2
TOZONE=$3
TOIP=$4
PORT=$5
SEQ_NUMBER=$6
BACKEND_ADDR=$7


#Schedula lo script per il il test
cline="~/Modeling4Cloud/utils/registerQperfCsv.sh $PROVIDER $FROMZONE $TOZONE $TOIP $PORT $SEQ_NUMBER > qperf-$FROMZONE-$TOZONE-$SEQ_NUMBER.out 2> qperf-$FROMZONE-$TOZONE-$SEQ_NUMBER.err < /dev/null &"
chmod +x ~/Modeling4Cloud/utils/registerQperfCsv.sh #Rende eseguibile lo script
#crontab -r #Rimuove tutti i crontab
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 */40 * * *' "$cline" ) | crontab - #ogni 10 minuti 
	echo Aggiunto job crontab per registerQperfCsv
else
	echo Crontab job già presente per registerQperfCsv
fi


#Schedula lo script per il caricamento al backend dei ping ogni mezzanotte
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $SEQ_NUMBER $BACKEND_ADDR ~/csvQperf"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh #Rende eseguibile lo script per il caricamento dei ping eseguiti
#crontab -r #Rimuove tutti i crontab
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 0 * * *' "$cline" ) | crontab -  
	echo Aggiunto job crontab per curlCsv
else
	echo Crontab job già presente per curlCsv
fi