# aursync

## Name

aursync - download and build AUR packages automatically

## Synopsis

aursync [+-cdi ARG] [+-knut] [--] ARGS...

## Description

Downloads and builds packages automatically using aurbuild. The arguments are package names.

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

__makepkg.conf__(5), __vifm__(1), __less__(1), __aurbuild__(1), __aurchain__(1), __aursift__(1), __aursearch__(1), __repofind__(1)

## Authors

Alad Wenter (https://github.com/AladW)
