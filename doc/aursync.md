# aursync

## Name

aursync - download and build AUR packages automatically

## Synopsis

aursync [+-cdi ARG] [+-knut] [--] ARGS...

## Description

Downloads, builds and adds AUR packages automatically to a local repository (local repositories are configured with the file:// prefix). In case there are multiple local repositories configured in pacman.conf, aursync asks which repository to add a package to.

In case vifm is installed, the downloaded files are shown using vifm and can be edited. If vifm is not installed, the files are shown in less or $PAGER if configured.

## Operations

* __-c__ Build packages in a chroot
* __-d__ Only download source files, don't build anything
* __-i__ Ignore package. Currently unused
* __-k__ Don't view downloaded files before building
* __-n__ Disable version checking for packages in the queue
* __-u__ Update packages in the custom repository
* __-t__ Download the PKGBUILDs using aria instead of git

## See also

__makepkg.conf__(5), __vifm__(1), __less__(1)

## Authors

Alad Wenter (https://github.com/AladW)
