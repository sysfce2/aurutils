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

The script `sync-list` achieves this by creating a copy of the local
repository, and extracting all entries which are part of the list and
their dependencies. The targets are then passed to `aur-sync(1)`, with
a temporary `pacman.conf` file that points to the copy.  Finally, the
copy is moved back to the original location.

This only addresses the contents of the local repository
(i.e. `custom.db`). Obsolete package files can be removed with
e.g. `repoctl update`.

While `sync-list` demonstrates how to manipulate both package files
and local repositories, there are often more simple approaches
available. In particular:

1. Only update the desired targets, e.g. `xargs -a list.txt aur sync`
   instead of `aur sync -u`
2. Recreate the local repository on every build
3. Use a "secondary" repository (e.g. `custom-testing`), moving
   packages to the "primary" repository after a certain time.

The second appraoch implies running `repo-add` for each package, which
may be slow for a large set of packages. The first alternative is
sufficient to avoid unused upgrades with `aur-sync -u`. Cleanups can
then be done periodically:

```bash
$ grep -Fxvf list.txt <(aur repo --list | cut -f1) | xargs -r repoctl rm
$ repoctl update
```

## chroot-batch

`aur-build` and `aur-chroot` elevate privileges on-demand with `sudo(8)`. This
typically results in password prompts when a certain time has elapsed, e.g. when
building larger packages. To avoid this, `sudoers(5)` can be configured to not
ask a password for relevant commands (see `aur-build(1)` and `aur-chroot(1)`).

An alternative is to run commands as the superuser, and drop privileges to a
separate user as needed. `chroot-batch` does so using `setpriv(1)`. In addition,
packages are signed with `gpg --pinentry-mode loopback` so that the script will
prompt for a `gpg(1)` passphrase once, with no keyring agents left running in
the background. This approach is taken from Xyne's
[`repo-add_and_sign`](https://xyne.dev/projects/repo-add_and_sign/) and requires
`allow-loopback-pinentry` in `$GNUPGHOME/gpg-agent.conf`.

To verify which packages are available in the local repository, `chroot-batch`
uses `aur build --dry-run --pkgver`. To disable this behavior, the `OVERWRITE`
variable can be set to `0`. The build user for `aur-build`, `gpg` and `repo-add`
defaults to `$SUDO_USER` and can be specified on the command-line.

Example usage:

```bash
$ aur sync -d custom --root /home/custompkgs --no-build >queue.txt
$ sudo chroot-batch queue.txt custom /home/custompkgs "$USER"
```
