The __contrib__ directory showcases use of various aurutils components, similar to the `EXAMPLES` section in `aur(1)`. Examples here do not necessarily fit into a single pipeline and are thus kept as separate programs.

To use a script with `aur(1)`, copy it to a directory in `PATH`. Alternatively, create a symbolic link if you have no local changes and always want to use the latest version.

```
$ cp -s /usr/share/aurutils/contrib/aur-vercmp-devel /usr/local/bin
$ aur vercmp-devel
```
