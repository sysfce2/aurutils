## SYNOPSIS
  
![logo](https://ptpb.pw/1Qal.png)

__aurutils__ is a collection of scripts to automate usage of the [Arch
User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository), 
with different tasks such as package searching, update checks, or computing 
dependencies kept separate.

The chosen approach for managing packages is local pacman
repositories, rather than foreign (installed by `pacman -U`)
packages.
  
## INSTALLATION

Install one of the following packages:

* [`aurutils`](https://aur.archlinux.org/packages/aurutils) for the
release version _(recommended)_.
* [`aurutils-git`](https://aur.archlinux.org/packages/aurutils-git)
for the master branch.

Upgrade notices are posted to the 
[Arch forums](https://bbs.archlinux.org/viewtopic.php?id=210621).
[(RSS)](https://bbs.archlinux.org/extern.php?action=feed&tid=210621&type=atom)

### Versioning

||Description|
|----|----|
|*Major changes*|Result in a bump of major version (`x.0.0`). Upgrades to a new major version may require a rewrite of interfacing software, or significant changes in workflow.|
|*Minor changes* (incompatible)|Result in a bump of minor version (`x.y.0`). Typically used for new command-line options, or other minor changes in behavior.|
|*Minor changes* (compatible)|Result in a bump of maintenance version (`x.y.z`). Typically used for bug fixes or new, compatible features.|

## USAGE

Documentation is included as groff manuals. [`aur(1)`](man1/aur.1) contains a
general overview, instructions on creating a local repository, and
several examples.

## TROUBLESHOOTING

See [ISSUE_TEMPLATE.md](ISSUE_TEMPLATE.md). For informal discussion, see the 
`#aurutils` channel on [freenode](https://freenode.net/kb/answer/chat).
