# aurutils

Collection of helper tools for use with the Arch User Repository.

## aurqueue

```aurqueue package dependency ...```

_package_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

## multireq

```multireq package ...```

_package_ must be the name of an AUR package. Dependencies are retrieved recursively.

## aurclone

```aurclone < FILE```
