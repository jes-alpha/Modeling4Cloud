HOST=$1
if [ ! $HOST ]
	then
	HOST=1
fi
if [ $HOST = 1 ]
	then
	echo Connecting 10.0.0.18
	ssh -i ~/keys/dpiscaglia.pem ubuntu@137.204.57.136
fi

if [ $HOST = 2 ]
	then
	echo Connecting 10.0.0.7
	ssh -o ProxyCommand="ssh -i ./keys/dpiscaglia.pem -W %h:%p ubuntu@137.204.57.136" -i ./keys/dpiscaglia.pem ubuntu@10.0.0.7
fi

if [ $HOST = 3 ]
	then
	echo Connecting 10.0.0.4
	ssh -o ProxyCommand="ssh -i ./keys/dpiscaglia.pem -W %h:%p ubuntu@137.204.57.136" -i ./keys/dpiscaglia.pem ubuntu@10.0.0.4
fi
