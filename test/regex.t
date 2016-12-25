#!/bin/bash
set -eux

aurgrep '.+' | tee pkglist.txt | xargs aursearch -Fr > aur.json
total1=$(jq -r '.[].results[] | .Name' < aur.json | wc -l)
total2=$(wc -l < pkglist.txt)
test "$total1" -eq "$total2"

