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
