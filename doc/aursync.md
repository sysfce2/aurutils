# aursync

## Name

aursync - download and build AUR packages automatically

## Synopsis

aursync [+-cdi ARG] [+-knut] [--] ARGS...

## Description

Downloads and builds AUR packages automatically. It asks which repository to use in case of multiple local repositories.

## Operations

* __-c__ Build packages in a chroot
* __-d__ Only download source files, don't build anything
* __-i__ Ignore package. Currently unused
* __-k__ Don't view downloaded files before building
* __-n__ Disable version checking for packages in the queue
* __-u__ Update packages in the custom repository
* __-t__ Download the PKGBUILDs using aria instead of git

All arguments after -- get passed to makepkg

## Authors

Alad Wenter (https://github.com/AladW)
