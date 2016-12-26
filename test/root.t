#!/bin/bash
set -eux

if (($# == 1)); then
    testrepo1=$1
else
    exit 1
fi

root1=$(pacconf --single --repo="$testrepo1" Server)
root1=${root1#*://}
cp -v "$root1/$1".db .

declare -i count1 count2
count1=$(aurcheck -aq "$testrepo1" | wc -l)
count2=$(aurcheck -aq "$testrepo1" -r . | wc -l)
test $count1 -eq $count2

repose -lr "$root1" "$testrepo1" > version
count1=$(aurcmp "$testrepo1" < version | wc -l)
count2=$(aurcmp "$testrepo1" -r . < version | wc -l)
test $count1 -eq $count2

mkdir aur1
AURDEST=$PWD/aur1 aursync --no-build --no-view --repo="$testrepo1" python-nikola
mkdir aur2
AURDEST=$PWD/aur2 aursync --no-build --no-view --repo="$testrepo1" --root=. python-nikola
count1=$(ls -1 ./aur1 | wc -l)
count2=$(ls -1 ./aur2 | wc -l)
test $count1 -eq $count2
