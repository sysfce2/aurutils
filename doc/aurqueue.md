# aurqueue

## Name

aurqueue - Order dependencies using .SRCINFO files

## Synopsis

aurqueue pkgbase [pkgbase, ...]

## Description

aurqueue takes the names of packages and orders the dependency chains using tsort.

For aurqueue to work, it is assumed that the source directories are already available and that it is used in the same directory as those source directories.

## See also

__datamash__(1), __tsort__(1)

## Authors

Alad Wenter (https://github.com/AladW)
