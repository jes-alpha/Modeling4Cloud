#!/bin/sh
PROVIDER=$1
SERVER=$3
FOLDER=$4

for file in ~/csvBenchmark/*;
do
curl -F "data=@${file}" $SERVER;
sudo rm -f $file;
done;
