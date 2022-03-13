This directory contains simple examples which combine `aur(1)`
programs. They typically have fixed options, are expected to be
modified by the user, and are documented line-by-line.

## sync-devel

The aim of this script is to take all VCS (version control) packages
in a local repository, update the source files to the latest upstream
revision, and build them if there are any changes. VCS packages
typically have `pkgver` set to the upstream revision at the time of
AUR package submission, and so are not automatically updated by
commands such as `aur-sync -u`.

The sample script retrieves the contents of the local repository with
`aur-repo --list`, and performs two updates:

1. Retrieve new AUR revisions with `aur-fetch(1)` and inspect them
   with `aur-view(1)`
2. Retrieve new upstream revisions with `aur-srcver(1)`

The first steps assumes all PKGBUILD directories are available in
`AURDEST` with `aur-fetch --existing`. If `AURDEST` exclusively
contains AUR packages, `aur-fetch` can be used without `--existing`.

In the second step, `makepkg -o` is run on each `PKGBUILD`, updating
`pkgver`.  The full version (`epoch:pkgver-pkgrel`) is then compared
to the contents of the local repository with `aur-vercmp(1)`. If there
is an update, the package is built with `aur-build(1)`.

## vercmp-devel

A simplified version of `sync-devel` which does only runs `aur-srcver`
and `aur-vercmp` on targets in the local repository.

## sync-list

When using `aur-sync(1)` or `aur-build(1)`, packages accumulate in
(one or several) local repositories. To avoid unused packages, a list
of packages can be created such that the local repository only
contains this list (and any dependencies).

The script `sync-list` achieves this by creating a copy of the
local repository, removing any packages from it which are not part of
the list and its dependencies.  Missing packages are then built with
`aur-build(1)` and added to this copy.  Finally, the copy is moved
back to the original location.

This only addresses the contents of the local repository
(i.e. `custom.db`), *not* any obsolete package files. These can be
removed with e.g. `repoctl update`.

It is assumed throughout that all build files are retrieved beforehand
(e.g. with `aur-fetch`) and that their dependency ordering is known
(e.g. with `aur-depends`). Example usage:

```bash
$ aur depends --pkgbase "$@" | tee queue | aur fetch --sync -
$ AUR_REPO=custom sync-list queue
```

Besides the approach above, one could:

1. Only update the desired targets, e.g. `xargs -a list.txt aur sync`
   instead of `aur sync -u`
2. Recreate the local repository on every build
3. Use a "temporary" repository (e.g. `custom-testing`), moving
   packages within after a certain time.

The second alternative implies running `repo-add` for each package,
which may be slow for a large set of packages. The first alternative
is sufficient to avoid unused upgrades with `aur-sync -u`. Cleanups
can then be done periodically:

```bash
$ grep -Fxvf list.txt <(aur repo --list | cut -f1) | xargs -r repoctl rm
$ repoctl update
```
