This directory contains simple examples which combine `aur(1)` programs. They
typically have fixed options, are expected to be modified by the user, and are
documented line-by-line.

## sync-devel

The aim of this script is to take all VCS (version control) packages in a local
repository, update the source files to the latest upstream revision, and build
them if there are any changes. VCS packages typically have `pkgver` set to the
upstream revision at the time of AUR package submission, and so are not
automatically updated by commands such as `aur-sync -u`.

The sample script retrieves the contents of the local repository with `aur-repo
--list`, and performs two updates:

1. Retrieve new AUR revisions with `aur-fetch(1)` and inspect them with
   `aur-view(1)`
2. Retrieve new upstream revisions with `aur-srcver(1)`

If PKGBUILD directories are not available in `AURDEST`, they are cloned anew
with `aur-fetch -e`. If the local repository exclusively contains AUR packages,
`aur-fetch` can be used without `--existing`.

The full version (`epoch:pkgver-pkgrel`) is then compared to the contents of the
local repository with `aur-vercmp(1)`. If there is an update, the package is
built with `aur-build(1)`.

## vercmp-devel

A simplified version of `sync-devel` which does only runs `aur-srcver` and
`aur-vercmp` on targets in the local repository.

Note: `aur-fetch` is not run in this script, and it is assumed all PKGBUILD
directories are available. This suggests to use a persistent directory for
`AURDEST`, instead of the default `$XDG_CACHE_HOME/aurutils/sync` used by
`aur-sync(1)`.

## sync-list

When using `aur-sync(1)` or `aur-build(1)`, packages accumulate in (one or
several) local repositories. To avoid unused packages, a list of packages can be
created such that the local repository only contains this list (and any
dependencies).

The script `sync-list` creates a copy of the local repository, and removes any
entries that are not part of the list or its dependencies with
`repo-remove`. Existing packages are symlinked in the temporary
directory. Targets are then passed to `aur-sync(1)`, with a temporary
`pacman.conf` file pointing to the temporary directory. Finally, the state is
transfered to the local repository with `rsync --delete`.

Other approaches include:

1. Only update the desired targets, e.g. `xargs -a list.txt aur sync` instead of
   `aur sync -u`
2. Recreate the local repository on every build
3. Use a "secondary" repository (e.g. `custom-testing`), moving packages to the
   "primary" repository after a certain time.

The second approach implies running `repo-add` for each package, which may be
slow for a large set of packages. The first alternative is sufficient to avoid
unused upgrades with `aur-sync -u`. Cleanups can then be done periodically:

```bash
$ grep -Fxvf list.txt <(aur repo --list | cut -f1) | xargs -r repo-purge -f custom
```

