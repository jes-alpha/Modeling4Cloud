#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=("AZR ./keys/jBianco.pem 13.77.157.237 137.135.243.195 westus2 northeurope 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AZR ./keys/jBianco.pem 137.135.243.195 ./keys/jBianco.pem 13.77.15.157.237 northeurope westus2 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
#qperfs=("AZR ./keys/jBianco.pem 40.89.141.170 ./keys/azr 40.113.125.208 fr-cent eu-occ 8080 1")
