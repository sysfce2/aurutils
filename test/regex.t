#!/bin/bash
set -eux

aurgrep '.+' | tee list.txt | xargs aursearch -Fr > list.json
total1=$(jq -r '.[]results[].Name' list.json | wc -l)
total2=$(wc -l list.txt)
test "$total1" -eq "$total2"

