# aurutils

Collection of helper tools for use with the Arch User Repository.

__EXPERIMENTAL — Use at your own risk.__

## aurqueue

```aurqueue pkgbase depends ...```

_pkgbase_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

## aurchain

```aurchain pkgname ...```

_pkgname_ must be the name of an AUR package. Dependencies are retrieved recursively.

## aursearch

```aursearch pattern```

Return JSON based on a PCRE pattern. Due to aurweb limitations, results are split by 150 matches, and searched by name only.

## aurbuild

```aurbuild QUEUE```

The QUEUE file must include names of directories containing a PKGBUILD file. file:// repositories are retrieved from /etc/pacman.conf.
