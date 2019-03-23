 #!/bin/bash
BACKENDADDRPINGS=http://3.83.232.170:3100/api/upload
BACKENDADDRBANDWITDHS=http://3.83.232.170:3100/api/uploadBandwidths
BACKENDADDRBENCHMARKS=http://3.83.232.170:3100/api/uploadBenchmarks

#./cleanCronAndReboot.sh ./allVM.sh

./hping/setupHping.sh ./AWS.sh $BACKENDADDRPINGS
./hping/setupHping.sh ./AZR.sh $BACKENDADDRPINGS
./hping/setupHping.sh ./IBM.sh $BACKENDADDRPINGS

./iperf/setupIperf.sh ./AWS.sh $BACKENDADDRBANDWITDHS
./iperf/setupIperf.sh ./AZR.sh $BACKENDADDRBANDWITDHS

./iperf/setupIperf.sh ./IBM.sh $BACKENDADDRBANDWITDHS

./hping/setupCrossHping.sh ./AWS.sh $BACKENDADDRPINGS
./iperf/setupCrossIperf.sh ./AWS.sh $BACKENDADDRBANDWITDHS

./sysbench/setupSysbench.sh ./allVM.sh $BACKENDADDRBENCHMARKS
