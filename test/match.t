#!/bin/bash
set -e

if (($# != 2)); then
    exit 1
else
    declare -r testrepo1=$1
    declare -r testrepo2=$2
fi

# exact repository match
total1=$(aurcheck -a "$testrepo1" 2>&1 | wc -l)
total2=$(pacman -Slq "$testrepo1" | wc -l)
test "$total1" -eq "$total2"

total1=$(aurcheck -a "$testrepo2" 2>&1 | wc -l)
total2=$(pacman -Slq "$testrepo2" | wc -l)
test "$total1" -eq "$total2"

aurcheck -a "$testrepo1" > out1.log
aurcheck -a "$testrepo2" > out2.log
datamash -W check < out1.log
datamash -W check < out2.log

