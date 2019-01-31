PORT=$1

if [ ! $PORT ]
	then
		PORT=80
fi


mkdir -p ~/Modeling4Cloud/utils/
sudo apt-get update -qq
#sudo apt-get install expect -qq
sudo apt-get install iperf3 -qq

cline="pgrep -x iperf3 | xargs -r sudo kill; nohup sudo iperf3 -s -p $PORT -D > iperfserver.out 2> iperfserver.err < /dev/null &"
if ! crontab -l | grep -q "$cline" ; then
	(crontab -l ; echo '*/30 * * * *' "$cline" ) | crontab - 
	echo Added iperServer crontab
else
	echo iperServer crontab already setup
fi

if pgrep -x iperf3 > /dev/null
	then
		echo iperf3 server already running
	else
		nohup sudo iperf3 -s -p $PORT -D > iperfserver.out 2> iperfserver.err < /dev/null &
fi
