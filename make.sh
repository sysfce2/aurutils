#!/bin/sh
if [ -d "$2" ]; then
    DESTDIR=$2
fi

case "$1" in
    check)
        LANG=C shellcheck -e 2016 -x bin/*
        ;;
    install)
        install -Dm755 bin/*          -t "$DESTDIR"/usr/bin/
        install -Dm644 completions/*  -t "$DESTDIR"/usr/share/zsh/site-functions/
        install -Dm644 man1/*         -t "$DESTDIR"/usr/share/man/man1/
        install -Dm644 man7/*         -t "$DESTDIR"/usr/share/man/man7/
        install -Dm644 LICENSE        -t "$DESTDIR"/usr/share/licenses/aurutils/
        install -Dm644 CREDITS README -t "$DESTDIR"/usr/share/doc/aurutils/
        ;;
esac
