# aurutils

Collection of helper tools for use with the Arch User Repository.

## aurbuild

```aurbuild [options] QUEUE```

The QUEUE file must include names of directories containing a PKGBUILD file. The ```-d``` (database), ```-r``` (root) and ```-p``` (pool) arguments are relayed to repose. ```-c``` builds a package in an nspawn-container (requires _devtools_).

## aurchain

```aurchain pkgname ...```

_pkgname_ must be the name of an AUR package. Dependencies are retrieved recursively, topologically sorted, and printed to stdout.

### Examples

Run actions on AUR targets in topological order:

```
 $ while read -r pkg; do ... done < <(aurchain _foobar_)
```

## aurqueue

```aurqueue pkgbase depends ...```

_pkgbase_ must be a directory containing a .SRCINFO file. Dependencies are not retrieved recursively, and must be specified on the command line for a complete graph.

### Examples

Build all packages in a github repository:

```
 $ git clone https://www.github.com/Earnestly/pkgbuilds
 $ cd pkgbuilds
 $ find -maxdepth 2 -name PKGBUILD -execdir mksrcinfo \;
 $ aurbuild -d custom.db -r /home/custompkgs -p /home/custompkgs <(aurqueue *)
```

## aursearch

```aursearch pattern```

Search AUR packages from a PCRE pattern. Due to aurweb limitations, results are searched by name only.

## aursift

```command ... | aursift | ...```

Filter input for packages in the official Arch Linux repositories. Virtual packages (provides/replaces) are solved.

### Examples

Search for perl modules that are both in the AUR and official repositories:

```
 $ aursearch -p '^perl-.+' > pkgs
 $ grep -Fxvf <(aursift < pkgs) pkgs
```

## aursync

Wrapper for aurchain and aurbuild. Build files are:

+ downloaded with `git` (`-t`: `.tar.gz` snapshots)
+ inspected with PAGER or, when installed, `vifm`
+ updated in case of VCS packages (`-n`: disable)
+ marked for building if newer (`-n`: disable)

To get started, create a local repository:

```
 $ sudo vim /etc/pacman.conf # uncomment [custom], change _Server_ to suit
 $ sudo install -d _/home/custompkgs_ -o $USER
 $ repo-add _/home/custompkgs/custom.db.tar_
 $ sudo pacman -Syu
```

### Examples

Build plasma-desktop-git and its dependencies (add `-c` to use an nspawn container):

```
 $ aursync plasma-desktop-git
```

Query the AUR for updates, and build the results:

```
 $ aursync $(repofind -u | awk '{print $1}')
```

Rebuild all packages in the _custom_ repository:

```
 $ aursync -nf $(pacman -Slq custom)
```
