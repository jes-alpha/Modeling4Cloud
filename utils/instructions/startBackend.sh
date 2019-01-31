#flag -i in bash necessario per caricare il sourcing in modo da poter eseguire npm
ssh -t -i ~/keys/dpiscaglia.pem ubuntu@137.204.57.136 'sudo bash -i -c " 


if [ ! -d ~/Modeling4Cloud ]; then
	git clone https://github.com/danipisca07/Modeling4Cloud.git
else
	cd ~/Modeling4Cloud
	#cp -n -rf ~/Modeling4Cloud/uploads/ ~/backupPings/
	#cp -n -rf ~/Modeling4Cloud/uploadsBW/ ~/backupBW/
	if pgrep node > /dev/null
	then
		echo A Node instance was running, it was killed.
		pgrep node | xargs sudo kill
	fi
	git pull --rebase https://github.com/danipisca07/Modeling4Cloud.git
fi


echo Setup backend
cd ~/Modeling4Cloud/backend

npm install
npm install -g nodemon
export PORT=3100
nohup nodemon --inspect start > backend.out 2> backend.err < /dev/null &

echo Setup frontend
cd ~/Modeling4Cloud/frontend

npm install
nohup npm run-script start-dev > frontend.out 2> frontend.err < /dev/null &
"'