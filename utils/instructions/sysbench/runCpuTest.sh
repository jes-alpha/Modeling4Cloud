#!/bin/bash
for each in 1 2 4 8 16 32 64;
do

line=$(sysbench cpu --cpu-max-prime=20000 --num-threads=$each run| egrep " cat|threads:|transactions|deadlocks|read/write|min:|avg:|max:|percentile:" | tr -d "\n" | sed 's/Number of threads: /\n/g' | sed 's/\[/\n/g' | sed 's/[A-Za-z\/]\{1,\}://g'| sed 's/ \.//g' | sed -e 's/read\/write//g' -e 's/approx\.  95//g' -e 's/per sec.)//g' -e 's/ms//g' -e 's/(//g' -e 's/^.*cat //g' | sed 's/ \{1,\}/, /g');

#echo `date`, $line>>sysbench.csv;

done