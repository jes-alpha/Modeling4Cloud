#!/bin/bash
crontab -r
at -l | awk '{printf "%s ", $1}' | xargs -r atrm
rm -f ~/*.out
rm -f ~/*.err
sudo reboot
