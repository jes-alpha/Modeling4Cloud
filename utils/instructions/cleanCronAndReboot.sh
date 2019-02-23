#!/bin/bash
CONFIG=$1

source $CONFIG

for i in "${allVM[@]}"
do

PROVIDER=$(echo $i | awk '{print $1}')
KEY=$(echo $i | awk '{print $2}')
HOST=$(echo $i | awk '{print $3}')

echo "deleting data for $PROVIDER $HOST"

ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$HOST bash -c "'
crontab -r
rm -f ~/*.out
rm -f ~/*.err
rm -f ~/*/*.csv
sudo reboot
'"
echo "deleted crontab and data for $PROVIDER $HOST"
echo "_____________ COMPLETED ______________"
done