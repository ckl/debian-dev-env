#!/bin/bash

free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%) [P::%.1f || B::%.1f || C::%.1f]\n", $3,$2,$3*100/$2,($3-$6-$7),$6,$7 }' 
df -h | awk '$NF=="/"{printf "Disk Usage: %s/%.1fGB (%s)\n", $3,$2,$5}'
top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' 
