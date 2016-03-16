# aurutils

Collection of helper tools for use with the Arch User Repository.

## aurbuild

```aurbuild [options] QUEUE```

The QUEUE file must include names of directories containing a PKGBUILD file. The ```-d``` (database), ```-r``` (root) and ```-p``` (pool) options are relayed to repose. ```-c``` builds a package in an nspawn-container (requires _devtools_).

## aurchain

```aurchain pkgname ...```

_pkgname_ must be the name of an AUR package. Dependencies are retrieved recursively.

## aurmaid

Wrapper for aurchain, aurqueue, and aurbuild. To get started, create a local repository:

```
 $ sudo vim /etc/pacman.conf # uncomment [custom]
 $ sudo install -d /home/packages -o $USER
```

## aurqueue

```aurqueue pkgbase depends ...```

_pkgbase_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

## aursearch

```aursearch pattern```

Return JSON based on a PCRE pattern. Due to aurweb limitations, results are split by 150 matches, and searched by name only.

## aursift

```command ... | aursift | ...```

Filter input for packages in the official Arch Linux repositories. Virtual packages (provides/replaces) are solved.
