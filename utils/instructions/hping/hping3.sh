HOST=$1
PORT=$2

if ![ $PORT]
	then
		PORT=22
fi
#sudo apt-get install hping3
sudo hping3 -S -p $PORT $HOST