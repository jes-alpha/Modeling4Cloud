#!/bin/bash
####Settings for hping direct tests
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=( "AWS ./keys/jBiancoNVirginia.pem 18.205.114.73 18.232.71.179 us-east-1c us-east-1a 1"
	"AWS ./keys/jBiancoNVirginia.pem 184.73.29.174 18.232.71.179 us-east-1a us-east-1a 2"
	"AWS ./keys/jBiancoNVirginia.pem 18.205.114.73 184.73.29.174 us-east-1c us-east-1a 3")

####Settings for iperf direct tests
#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AWS ./keys/jBiancoNVirginia.pem 18.205.114.73 ./keys/jBiancoNVirginia.pem 184.73.29.174 us-east-1c us-east-1a 80 1 14 1 1" 
	"AWS ./keys/jBiancoNVirginia.pem 18.205.114.73 ./keys/jBiancoIreland.pem 34.244.169.175 us-east-1c eu-west-1c 80 2 14 1 1" 
	"AWS ./keys/jBiancoLondon.pem 18.130.96.67 ./keys/jBiancoIreland.pem 34.244.169.175 eu-west-2a eu-west-1c 80 3 14 1 1" 
	"AWS ./keys/jBiancoLondon.pem 18.130.96.67 ./keys/jBiancoNVirginia.pem 18.205.114.73 eu-west-2a us-east-1c 80 4 14 1 1")

####Settings for crossregion and sameregion tests
#Global settings
PROVIDER=AWS

#Hping settings
HPINGBASEPORT=6000 #Starting port of the incremental range for hping used ports
HPING_SECONDS_INTERVAL=10 #Time between tests in seconds
HPING_BIDIRECTIONAL=0 #Test in both directions between regions(1) or not(0)

#Iperf settings
PORT=80 #Port used for iperf tests
IPERF_HOUR_INTERVAL=25 #Time between tests in hours
DURATION=1 #Duration of each bandwitdh test
PARALLEL=1 #Number of parallel connection opened by each iperf bandwidth test
IPERF_BIDIRECTIONAL=0 #Test in both directions between regions(1) or not(0)

#Information about vms to use for the cross region tests
vms=(
"./keys/jBiancoNVirginia.pem 18.205.114.73 us-east-1c"
"./keys/jBiancoIreland.pem 34.244.169.175 eu-west-1c"
"./keys/jBiancoLondon.pem 18.130.96.67 eu-west-2a"
)
