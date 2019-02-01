#!/bin/bash
#Provider, source-ssh-keyfile source-ip destination-ip source-zone destination-zone sequence-number
pings=("GCP ./keys/gcp 35.240.56.132 35.242.174.100 eu-west1-b eu-west2-a 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number hour-interval duration parallel
iperfs=("GCP ./keys/gcp 35.240.56.132 ./keys/gcp 35.242.174.100 eu-west1-b eu-west2-a 80 1 14 1 1")

#Provider, source-ssh-keyfile source-ip destination-ssh-keyfile destination-ip source-zone destination-zone connection-port sequence-number
qperfs=("GCP ./keys/gcp 35.240.56.132 ./keys/gcp 35.242.174.100 eu-west2-a eu-west1-b 8080 1")