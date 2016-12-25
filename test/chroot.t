#!/bin/bash
set -eux

if (($# != 2)); then
    exit 1
else
    declare -r testrepo1=$1
    declare -r testroot1=$2
fi

test -d "$testroot1" && sudo rm -rf "$testroot1"
server1=$(pacconf --single Server --repo="$testrepo1")
repose --root "${server1#*://}" "$testrepo1"
sudo pacsync "$testrepo1"

AURDEST=$PWD aursync --no-build --no-view aurutils-git
printf '%s\n' aurutils-git > argfile
aurbuild -cd "$testrepo1" -C "$testroot1" -a argfile
aurbuild -cd "$testrepo1" -a argfile # default location

sudo pacsync "$testrepo1"
pacman -Si "$testrepo1"/aurutils-git # Repository move

