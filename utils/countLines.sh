#!/bin/bash
COUNT=0;
SUM=0;
CURRENTLINES=0;

for filename in ../uploads/*.csv;
do
    if [[ $filename != *"22.csv" ]];
        then
            CURRENTLINES=`cat $filename | wc -l`
            SUM=$((SUM + CURRENTLINES))
            COUNT=$((COUNT + 1)) # headings
    fi
done;

echo $((SUM-COUNT));