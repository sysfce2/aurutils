# aurutils

Collection of helper tools for use with the Arch User Repository.

__Experimental --- Use at your own risk.__

## aurqueue

```aurqueue package dependency ...```

_package_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

## aurchain

```aurchain package ...```

_package_ must be the name of an AUR package. Dependencies are retrieved recursively.

## aurclone

```aurclone < FILE```

Input must contain single package names, available via https://aur.archlinux.org.

## aursearch

```aursearch pattern```

Return JSON based on a PCRE pattern. Due to aurweb limitations, results are split by 150 matches, and searched by name only.

## aurbuild

```aurbuild < FILE```

Input must contain directories containing a PKGBUILD file. Built packages are stored in a local repository.

## aurbob

TBD
