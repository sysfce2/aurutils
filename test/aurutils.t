#!/bin/bash
set -e
basedir=$PWD
tmp=$(mktemp -d)

declare -ra testrepo=(aurutils-test aurutils-test-vcs)
declare -ra testroot=(/var/tmp/test-chroot)
declare -r basedir tmp

prepare_repo() {
    declare -i purge

    for i; do
        declare repo=$i server
        server=$(pacconf --single Server --repo="$repo")
        server=${server#*://}

        if ((purge)); then
            find "$server" -type f \( -name '*.pkg*' \
                 -or -name '*.db*' \
                 -or -name '*.files*' \) -delete
        fi

        repose --root "$server" "$repo"
    done

    sudo pacsync "$@"
}

trap 'rm -rf $tmp' EXIT
source /usr/share/makepkg/util.sh

if [[ -t 2 ]]; then
    colorize
fi

cd_safe "$tmp"

case $1 in
    chroot)
        prepare_repo "${testrepo[0]}"
        "$basedir"/chroot.t "${testrepo[0]}" "${testroot[0]}"
        ;;
    package)
        purge=1 prepare_repo "${testrepo[@]:0:2}"
        "$basedir"/package.t "${testrepo[@]:0:2}"
        ;;
    match)
        prepare_repo "${testrepo[@]:0:2}"
        "$basedir"/match.t "${testrepo[@]:0:2}"
        ;;
    random)
        prepare_repo "${testrepo[0]}"
        "$basedir"/random.t "${testrepo[0]}"
        ;;
    regex)
        "$basedir"/regex.t   
        ;;
    root)
        prepare_repo "${testrepo[0]}"
        "$basedir"/root.t "${testrepo[@]:0:2}"
        ;;
esac

# vim: set et sw=4 sts=4 ft=sh:
