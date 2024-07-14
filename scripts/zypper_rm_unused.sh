#!/bin/sh

# Copied from somewhere on the internet
zypper packages --unneeded | awk -F'|' 'NR==0 || NR==1 || NR==2 || NR==3 || NR==4 {next} {print $3}' > list
while read p; do zypper info $p && zypper se --requires $p && zypper rm $p; done  < list
rm -rf list
