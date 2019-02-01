#!/bin/bash
#!/bin/bash

ssh -q -o ProxyCommand="ssh -i ./keys/dpiscaglia.pem -W %h:%p ubuntu@137.204.57.136" -i ./keys/dpiscaglia.pem ubuntu@10.0.0.7 < ./mongo/setupShard1.sh
ssh -q -o ProxyCommand="ssh -i ./keys/dpiscaglia.pem -W %h:%p ubuntu@137.204.57.136" -i ./keys/dpiscaglia.pem ubuntu@10.0.0.4 < ./mongo/setupShard2.sh
ssh -q -t -i ~/keys/dpiscaglia.pem ubuntu@137.204.57.136 < ./mongo/setupConfig.sh
ssh -q -t -i ~/keys/dpiscaglia.pem ubuntu@137.204.57.136 < ./mongo/setupMongos.sh
ssh -q -t -i ~/keys/dpiscaglia.pem ubuntu@137.204.57.136 < ./mongo/importData.sh
