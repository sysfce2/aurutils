## contrib

The __contrib__ directory includes (simple or other) programs that are not part
of the main aurutils suite.

To use a script with `aur(1)`, copy it to a directory in
`PATH`. Alternatively, create a symbolic link if you have no local
changes. 

For example:

```
$ cp -s /usr/share/aurutils/contrib/vercmp-devel /usr/local/bin/aur-vercmp-devel
$ aur vercmp-devel
```

### Third-party projects

* [aur-out-of-date](https://aur.archlinux.org/packages/aur-out-of-date/)
* [aur-talk](https://aur.archlinux.org/packages/aur-talk-git/)
