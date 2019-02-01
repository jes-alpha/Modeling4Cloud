#!/bin/bash
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=("IBM ./keys/ibm 159.122.184.179 159.8.123.35 MIL01 PAR01 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("IBM ./keys/ibm 159.122.184.179  ./keys/ibm 159.8.123.35 MIL01 PAR01 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=("IBM ./keys/ibm 159.8.123.35 ./keys/ibm 159.122.184.179 PAR01 MIL01 8080 1")