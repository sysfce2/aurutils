#!/bin/bash
set -e
basedir=$PWD
tmp=$(mktemp -d)

declare -ra testrepo=(aurutils-test aurutils-test-vcs)
declare -ra testroot=(/var/tmp/test-chroot)
declare -r basedir tmp

trap 'rm -rf $tmp' EXIT
source /usr/share/makepkg/util.sh

[[ -t 2 ]] && colorize
cd_safe "$tmp"

for i in "${testrepo[@]}"; do
    server=$(pacconf --single Server --repo="$i")
    server=${server#*://}

    find "$server" -type f \( -name '*.pkg*' -or -name '*.db*' -or -name '*.files*' \) -delete
    repo-add "$server/$i".db.tar
done

sudo pacsync "${testrepo[@]}"

"$basedir"/chroot.t "${testrepo[0]}" "${testroot[0]}"
"$basedir"/match.t "${testrepo[@]:0:2}"
"$basedir"/package.t "${testrepo[@]:0:2}"
"$basedir"/random.t "${testrepo[0]}"
"$basedir"/regex.t   
#./root.t "${testrepo[0]}"
#./sign.t

# vim: set et sw=4 sts=4 ft=sh:
