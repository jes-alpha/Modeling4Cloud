#!/bin/bash
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=(
    "AZR ./keys/jBianco.pem 51.140.46.97 40.127.204.63 uksouth northeurope 1"
    )

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
#iperfs=("AZR ./keys/jBianco.pem 40.113.70.169 ./keys/jBianco.pem 104.214.219.149 northeu westeu 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
 #qperfs=("AZR ./keys/jBianco.pem 40.113.70.169 ./keys/jBianco.pem 104.214.219.149 northeu westeu 8080 1")
