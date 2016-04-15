# aurbuild

## Name

aurbuild - Build packages to a local repository

## Synopsis

aurbuild [+-a ARG] [+-cd ARG] [+-p ARG] [+-r ARG} [--] ARGS...

## Description

Build a package from a queue file and add them to a local repository. A local repository is a repository on the local file system. It is configured using the file:// prefix for Server in pacman.conf.

## Operations

* __-a__ A text file with directories containing PKGBUILDs (
* __-c__ Build in a chroot
* __-d__ The name of the database
* __-p__ Select the pool for the built packages. The pool is the location where aurbuild will put the packages after building
* __-r__ Select the root for the repository where the database files will live

All arguments after -- get passed to makepkg

## See also

__repose__(1), __makepkg__(8), __pacman.conf__(5)

## Authors

Alad Wenter (https://github.com/AladW)
