#!/bin/bash
set -e
basedir=$PWD
tmp=$(mktemp -d)

declare -ra testrepo=(aurutils-test aurutils-test-vcs)
declare -ra testroot=(/var/tmp/test-chroot)
declare -r basedir tmp

trap 'rm -rf $tmp' EXIT
source /usr/share/makepkg/util.sh

if [[ -t 2 ]]; then
    colorize
fi

cd_safe "$tmp"

case $1 in
    chroot)
        "$basedir"/chroot.t "${testrepo[0]}" "${testroot[0]}"
        ;;
    match)
        "$basedir"/match.t "${testrepo[@]:0:2}"
        ;;
    package)
        "$basedir"/package.t "${testrepo[@]:0:2}"
        ;;
    random)
        "$basedir"/random.t "${testrepo[0]}"
        ;;
    regex)
        "$basedir"/regex.t   
        ;;
    root)
        "$basedir"/root.t "${testrepo[0]}"
        ;;
    *)
        
esac

# vim: set et sw=4 sts=4 ft=sh:
