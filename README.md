## SYNOPSIS
  
__aurutils__ is a collection of scripts to automate usage of the [Arch
User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository), 
with different tasks such as package searching, update checks, or computing 
dependencies kept separate.

The chosen approach for managing packages is local pacman
repositories, rather than foreign (installed by `pacman -U`)
packages.
  
## INSTALLATION

The master branch can be installed from the included `Makefile`,
or from the AUR under `aurutils-git`.

https://aur.archlinux.org/packages/aurutils-git

The release version is available in the AUR under `aurutils`.

https://aur.archlinux.org/packages/aurutils

Upgrade notices are posted to the Arch forums:

https://bbs.archlinux.org/viewtopic.php?id=210621

https://bbs.archlinux.org/extern.php?action=feed&tid=210621&type=atom (RSS)

## USAGE

Documentation is included as groff manuals. [`aurutils(7)`](man7/aurutils.7) contains a
general overview, instructions on creating a local repository, and
several examples.

The various scripts are documented by pages in section 1, for
example [`aursync(1)`](man1/aursync.1).

## TROUBLESHOOTING

See [CONTRIBUTING.md](CONTRIBUTING.md).
