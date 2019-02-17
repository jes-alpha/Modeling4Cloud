#!/bin/bash
CONFIG=$1

source $CONFIG

for i in "${allVM[@]}"
do

PROVIDER=$(echo $i | awk '{print $1}')
KEY=$(echo $i | awk '{print $2}')
HOST=$(echo $i | awk '{print $3}')

echo "$HOST"

ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
crontab -r
#at -l | awk '{printf "%s ", $1}' | xargs -r atrm
#rm -f ~/*.out
#rm -f ~/*.err
sudo reboot
'"
echo "deleted crontab for $HOST"
done