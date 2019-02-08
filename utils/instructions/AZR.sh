#!/bin/bash
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=(
    "AZR ./keys/jBianco 13.79.31.97 52.187.243.229 north-eu aus 1"
    )

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AZR ./keys/jBianco 13.79.31.97 ./keys/jBianco 52.187.243.229 north-eu aus 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=("AZR ./keys/jBianco 13.79.31.97 ./keys/jBianco 52.187.243.229 north-eu aus 8080 1")
