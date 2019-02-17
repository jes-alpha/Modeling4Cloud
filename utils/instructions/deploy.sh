 #!/bin/bash
BACKENDADDRPINGS=http://54.234.131.88:3100/api/upload
BACKENDADDRBANDWITDHS=http://54.234.131.88:3100/api/uploadBandwidths
BACKENDADDRBENCHMARKS=http://54.234.131.88:3100/api/uploadBenchmarks
#./cleanCronAndReboot.sh ./allVM.sh

./hping/setupHping.sh ./AWS.sh $BACKENDADDRPINGS
./hping/setupHping.sh ./AZR.sh $BACKENDADDRPINGS
#./hping/setupHping.sh ./GCP.sh $BACKENDADDRPINGS
#./hping/setupHping.sh ./IBM.sh $BACKENDADDRPINGS

./iperf/setupIperf.sh ./AWS.sh $BACKENDADDRBANDWITDHS
./iperf/setupIperf.sh ./AZR.sh $BACKENDADDRBANDWITDHS
#./iperf/setupIperf.sh ./GCP.sh $BACKENDADDRBANDWITDHS
#./iperf/setupIperf.sh ./IBM.sh $BACKENDADDRBANDWITDHS

#./qperf/setupQperf.sh ./AWS.sh $BACKENDADDRBANDWITDHS
#./qperf/setupQperf.sh ./AZR.sh $BACKENDADDRBANDWITDHS
#./qperf/setupQperf.sh ./GCP.sh $BACKENDADDRBANDWITDHS
#./qperf/setupQperf.sh ./IBM.sh $BACKENDADDRBANDWITDHS

./hping/setupCrossHping.sh ./AWS.sh $BACKENDADDRPINGS
./iperf/setupCrossIperf.sh ./AWS.sh $BACKENDADDRBANDWITDHS

./sysbench/setupSysbench.sh ./allVM $BACKENDADDRBENCHMARKS
