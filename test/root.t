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

repose -lr "$root1" "$testrepo1" > version
count1=$(aurcmp "$testrepo1" < version | wc -l)
count2=$(aurcmp "$testrepo1" -r . < version | wc -l)
test $count1 -eq $count2

AURDEST=$PWD aursync --no-build --no-view --update \
       --repo="$testrepo1" --root="$PWD" python-nikola
