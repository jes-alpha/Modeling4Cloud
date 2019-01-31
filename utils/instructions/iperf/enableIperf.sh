PROVIDER=$1
FROMZONE=$2
TOZONE=$3
FROMIP=$4
TOIP=$5
PORT=$6
SEQ_NUMBER=$7
BACKEND_ADDR=$8
HOUR_INTERVAL=$9
DURATION=${10}
PARALLEL=${11}

#Schedula lo script per il caricamento al backend dei ping ogni mezzanotte
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $SEQ_NUMBER $BACKEND_ADDR ~/csvIperf"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh #Rende eseguibile lo script per il caricamento dei ping eseguiti
#crontab -r #Rimuove tutti i crontab
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '0 0 * * *' "$cline" ) | crontab - 
	echo Added iperfCurl crontab
else
	echo iperfCurl crontab already setup
fi

chmod +x ~/Modeling4Cloud/utils/registerIperfCsv.sh #Rende eseguibile lo script

bash ~/Modeling4Cloud/utils/registerIperfCsv.sh $PROVIDER $FROMZONE $TOZONE $FROMIP $TOIP $PORT $SEQ_NUMBER $HOUR_INTERVAL $DURATION $PARALLEL > iperf-$FROMZONE-$TOZONE-$SEQ_NUMBER.out 2> iperf-$FROMZONE-$TOZONE-$SEQ_NUMBER.err < /dev/null &


