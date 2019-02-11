#!/bin/bash
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=("AZR ./keys/jBianco.pem 20.187.2.141 168.63.37.89 westus2 northeurope 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("AZR ./keys/jBianco.pem 20.187.2.141 ./keys/jBianco.pem 168.63.37.89 westus2 northeurope 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
#qperfs=("AZR ./keys/jBianco.pem 40.89.141.170 ./keys/azr 40.113.125.208 fr-cent eu-occ 8080 1")
