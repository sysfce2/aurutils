This directory contains simple examples which combine `aur(1)` programs. They
typically have fixed options and are documented line-by-line.

## aur-sync-devel

The aim of this script is to take all VCS (version control) packages in a local
repository, update the corresponding source files to the latest upstream
revision, and build them if there are any changes. This is done because VCS
packages typically have `pkgver` set to the upstream revision at the time of
AUR package submission.

The sample script performs two updates:
1. Retrieve new AUR revisions with `aur-fetch(1)` and inspect them with `aur-view(1)`
2. Retrieve new upstream revisions with `aur-srcver(1)`

In the second step, `makepkg -o` is run on each `PKGBUILD`, updating `pkgver`.
The full version (`epoch:pkgver-pkgrel`) is then compared to the contents of
the local repository with `aur-vercmp(1)`. If there is an update, the package
is built with `aur-build(1)`.

## aur-sync-list

When using `aur-sync(1)` or `aur-build(1)`, packages accumulate in (one or several)
local repositories. To avoid unused packages, a list of packages can be created
such that the local repository only contains this list (and any dependencies).

The script `aur-sync-list` achieves this by creating a copy of the local repository,
removing any packages from it which are not part of the list and its dependencies.
Packages that are missing are then built with `aur-build(1)` and added to this copy.
Finally, the copy is moved back to the original location.

This only addresses the contents of the local repository (i.e. `custom.db`), *not*
any obsolete package files. These can be removed with e.g. `repoctl update`.

Besides the approach above, one could:
1. Only update the desired targets, e.g. `xargs -a list.txt aur sync` instead of `aur sync -u`
2. Recreate the local repository on every build, by skipping builds for existing packages
3. Use a "temporary" repository (e.g. `custom-testing`), moving packages within after a certain time.

Note that the second alternative, while possible with `aur-build` >=3.2.0, can be slow 
for a large set of packages. The first alternative is sufficient to avoid building unused 
upgrades with `aur-sync -u`, and cleanups can be done periodically:

```bash
$ grep -Fxvf list.txt <(aur repo --list | cut -f1) | xargs -r repoctl rm
$ repoctl update
```
