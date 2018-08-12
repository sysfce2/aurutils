The __contrib__ directory includes (simple or other) programs that are not part
of the main aurutils suite.

To use a script with `aur(1)`, copy it to a directory in
`PATH`. Alternatively, create a symbolic link if you have no local
changes and always want to use the latest version.

```
$ cp -s /usr/share/aurutils/contrib/vercmp-devel /usr/local/bin/aur-vercmp-devel
$ aur vercmp-devel
```

## vercmp-devel

This script takes the contents of a local repository (`aur sync
--list`) and matches them against a common pattern for VCS packages
(`grep -E $AURVCS`). It then looks in the `aur-sync` cache (`find
$AURDEST`) for relevant directories. Any existing `PKGBUILD`s in these
directories are executed, with upstream sources updated to their
latest revision. (`aur srcver` using `makepkg -o`)

In the last line, the resulting package versions (`vcs_info`) are
compared against the local repository (`db_info`). If the package
version is newer, it is printed to `stdout`. This may be combined with
`aur-sync`:

```
aur vercmp-devel | cut -d: -f1 >vcs.txt
xargs -a vcs.txt aur sync --no-ver-shallow
```

VCS packages typically have `pkgver` set to the upstream revision at
the time of package submission, making the AUR-advertised version
older than the latest version. Here, the `--no-ver-shallow` option
ignores the AUR information _only_ for packages from standard input
(`-`).

Further arguments can be added to `aur-sync`, such as `--upgrades` to
update regular and VCS packages in one go.

----
As described, the above relies on already available `PKGBUILD`s. If
the `aur-sync` cache is sparse or the package has meanwhile been
updated by the AUR maintainer (for example, to indicate a new
upstream), information reported by `vercmp-devel` may be
incomplete.

The following mediates this by downloading all VCS packages in a local
repository anew, with all build files and their diffs offered for
inspection.

```
aur sync --list | cut -f2 | grep -E "$AURVCS" | xargs aur sync --no-ver --print
```

[//]: # (The last pipeline will also show any non-VCS dependencies.)
[//]: # (Since the respective PKGBUILDs are not run by aur-srcver,)
[//]: # (they are not of relevance. Use aur-fetch manually?)
