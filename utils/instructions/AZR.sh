#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=("AZR ./keys/azr 40.113.125.208 40.89.141.170 eu-occ fr-cent 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AZR ./keys/azr 40.89.141.170 ./keys/azr 40.113.125.208 fr-cent eu-occ 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=("AZR ./keys/azr 40.89.141.170 ./keys/azr 40.113.125.208 fr-cent eu-occ 8080 1")
