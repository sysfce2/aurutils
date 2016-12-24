#!/bin/bash
set -e
tmp=$(mktemp -d)

declare -ra testrepo=(aurutils-test aurutils-test-vcs)
declare -ra testroot=(/var/tmp/test-chroot)
declare -r tmp

trap 'rm -rf $tmp' EXIT
source /usr/share/makepkg/util.sh

[[ -t 2 ] && colorize
cd_safe "$tmp"

for i in "${testrepo[@]}"; do
    server=$(pacconf --single Server --repo="$i")
    server=${server#://}

    find "$server" -type f \( -name '*.pkg*' -or -name '*.db*' -or -name '*.files*' \) -delete
    repo-add "$server/$i".db.tar
done

sudo pacsync "${testrepo[@]}"

./chroot.t "${testrepo[0]}" "${testroot[0]}"
./match.t "${testrepo[@]:0:2}"
./package.t "${testrepo[@]:0:2}"
./random.t "${testrepo[0]}"
./regex.t   
#./root.t "${testrepo[0]}"
#./sign.t

# vim: set et sw=4 sts=4 ft=sh:
