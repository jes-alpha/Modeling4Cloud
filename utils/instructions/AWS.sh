#!/bin/bash
#!/bin/bash
####Settings for hping direct tests
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=(
	"AWS ./keys/jBiancoNVirginia.pem 18.234.104.108 54.147.108.66 us-east-1c us-east-1a 2"
	)


####Settings for iperf direct tests
#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=(
	"AWS ./keys/jBiancoNVirginia.pem 18.234.104.108 ./keys/jBiancoIreland.pem 34.245.60.97 us-east-1c eu-west-1c 80 1 14 1 1" 
	)


####Settings for qperf direct tests
#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=(
	"AWS ./keys/jBiancoIreland.pem 34.245.60.97 ./keys/jBiancoNVirginia.pem 18.234.104.108 eu-west-1c us-east-1c 8080 1"
	)


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
"./keys/jBiancoNVirginia.pem 18.234.104.108 us-east-1c"
"./keys/jBiancoIreland.pem 34.245.60.97 eu-west-1c"
"./keys/jBiancoLondon.pem 3.8.148.33 eu-west-2a"
)
