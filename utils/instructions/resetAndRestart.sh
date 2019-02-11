

for a in "${awsProbes[@]}"

	KEY=$(echo $a | awk '{print $1}')
	HOST=$(echo $a | awk '{print $2}')
	
    echo deleting $HOST..
	ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST 'sudo bash -i -c "

    crontab -r
    rm -f ~/*.out
    rm -f ~/*.err
    rm -f ~/*.sh
    rm -f -r ~/csv
    rm -f -r ~/csvIperf
    rm -f -r ~/Modeling4Cloud
    "'
do

echo end