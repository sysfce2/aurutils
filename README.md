# aurutils

Collection of small helper tools for use with the Arch User Repository.

## aurqueue

```aurqueue package dependency ...```

_package_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

## multireq

```multireq package```

_package_ is the name of an AUR package. Dependencies are retrieved recursively.

# TODO

+ Write a proper man page, see man-pages(7)
+ aurbuild - build script using repose. Mostly done, but makepkg doesn't play nice.
+ aurclone - clone script
+ revisit multireq sequential curl use
+ Allow to exclude a local repository in sift()
  + Don't filter command-line arguments?
  + pacsift --regex --repo=<pattern>
