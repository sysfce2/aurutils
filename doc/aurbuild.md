# aurbuild

## Name

aurbuild - Build packages to a local repository

## Synopsis

aurbuild [+-a ARG] [+-cd ARG] [+-p ARG] [+-r ARG} [--] ARGS...

## Description

Build the packages from a PKGBUILD and add them to a local repository. The PKGBUILD file must be given, just like the name of the database and the directories for the packages and the database files.

## Operations

* __-a__ The PKGBUILD files to build
* __-c__ Build in a chroot
* __-d__ The name of the database (required)
* __-p__ Select the location to put the built packages (required)
* __-r__ Select the root for the repository where the database files will live (required)

All arguments after -- get passed to makepkg

## See also

## Authors
