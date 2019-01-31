####Settings for hping direct tests
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=(
		"AWS ./keys/aws-imol-virginia.pem 54.147.226.152 18.130.223.116 us-east-1 eu-west-2c 2" 
		"AWS ./keys/aws-imol-tokyo.pem 18.179.61.138 18.130.223.116 ap-northeast-1 eu-west-2c 3" 
		"AWS ./keys/aws-imol-virginia.pem 54.147.226.152 18.179.61.138 ap-northeast-1 us-east-1 4")



####Settings for iperf direct tests
#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AWS ./keys/aws-imol-london.pem 18.130.223.116 ./keys/aws-imol-paris.pem 35.180.92.154 eu-west-2c eu-west-3c 80 1 14 1 1" 
	"AWS ./keys/aws-imol-virginia.pem 54.147.226.152 ./keys/aws-imol-london.pem 18.130.223.116 us-east-1 eu-west-2c 80 2 14 1 1" 
	"AWS ./keys/aws-imol-tokyo.pem 18.179.61.138 ./keys/aws-imol-london.pem 18.130.223.116 ap-northeast-1 eu-west-2c 80 3 14 1 1" 
	"AWS ./keys/aws-imol-virginia.pem 54.147.226.152 ./keys/aws-imol-tokyo.pem 18.179.61.138 ap-northeast-1 us-east-1 80 4 14 1 1")




####Settings for qperf direct tests
#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=("AWS ./keys/aws-imol-paris.pem 35.180.92.154 ./keys/aws-imol-london.pem 18.130.223.116 eu-west-3c eu-west-2c 8080 1")




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
"./keys/aws-imol-virginia.pem 107.21.185.163 us-east-1"
"./keys/aws-imol-ohio.pem 18.222.248.68 us-east-2"
"./keys/aws-imol-california.pem 54.183.120.193 us-west-1"
"./keys/aws-imol-oregon.pem 54.200.106.63 us-west-2"
"./keys/aws-imol-mumbai.pem 35.154.221.120 ap-south-1"
"./keys/aws-imol-seoul.pem 52.79.107.222 ap-northeast-2"
"./keys/aws-imol-singapore.pem 54.169.139.66 ap-southeast-1"
"./keys/aws-imol-sydney.pem 54.206.99.141 ap-southeast-2"
"./keys/aws-imol-tokyo.pem 18.179.61.138 ap-northeast-1"
"./keys/aws-imol-canada.pem 35.183.41.6 ca-central-1"
"./keys/aws-imol-frankfurt.pem 35.159.33.175 eu-central-1"
"./keys/aws-imol-ireland.pem 34.249.20.202 eu-west-1"
"./keys/aws-imol-london.pem 18.130.223.116 eu-west-2"
"./keys/aws-imol-paris.pem 35.180.92.154 eu-west-3"
"./keys/aws-imol-saopaulo.pem 18.231.177.17 sa-east-1"
)
