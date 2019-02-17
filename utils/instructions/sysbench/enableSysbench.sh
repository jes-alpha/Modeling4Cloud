#!/bin/bash
PROVIDER=$1
HOST=$2
BACKEND_ADDR=$3

cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $BACKEND_ADDR ~/csvBenchmark"
chmod +x ~/Modeling4Cloud/utils/registerSysbenchCsv.sh #Rende eseguibile lo script per il pinging
nohup ~/Modeling4Cloud/utils/registerSysbenchCsv.sh $PROVIDER $HOST > $HOST.out 2> $host.err < /dev/null &
#~/Modeling4Cloud/utils/registerHpingCsv.sh $PROVIDER $FROMZONE $TOZONE $TOIP $SEQ_NUMBER


#Schedula lo script per il caricamento al backend dei ping ogni mezzanotte
cline="~/Modeling4Cloud/utils/curlCsv.sh $PROVIDER $BACKEND_ADDR ~/csv"
chmod +x ~/Modeling4Cloud/utils/curlCsv.sh #Rende eseguibile lo script per il caricamento dei ping eseguiti
#crontab -r #Rimuove tutti i crontab
if ! crontab -l | grep -q "$cline" ; then
    (crontab -l ; echo '0 0 * * *' "$cline" ) | crontab -
    echo Added hpingCurl crontab
else
    echo hpingCurl crontab already setup
fi

mkdir -p ~/Modeling4Cloud/utils/
sudo apt-get update -qq
chmod +x  ~/runCpuTest.sh #TODO check  path
if crontab -l | grep -q "$cline" ;
then
    echo "sysbench crontab already set, updating"
fi
	crontab -e */30 * * * * ~/runCpuTest.sh > sysbench.out 2> sysbench.err < /dev/null &
	echo added sysbench crontab