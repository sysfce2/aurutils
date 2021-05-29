## SYNOPSIS
  
![logo](06Nitori1.png)

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

### SIGNATURES

Release archives are signed with `signify` with the following public keys:

* `RWQawitEue1JU2SxUyRD8LXP8m36QsbaHOkKfvZBfhj00EXBYiDZilp0` for `2.3.x`;
* `RWQcfDbvctqX5i5yNDNqu607LC7mKArHMsq7ziT8ynx9bQwj5m5ZpMJY` for `3.0.x`;
* `RWSiKm8qeKjPfppkN7lm/N4qENa3Racl7DRMfWK4JQS7bl2i/NuI3ZZG` for `3.1.x`;

The above keys are also published on [ArchWiki](https://wiki.archlinux.org/index.php/User:Alad#Signing_keys).

A release archive can be verified with the following command:
```
signify -V -p aurutils.pub -m <version>.tar.gz
```

## USAGE

Documentation is included as groff manuals. [`aur(1)`](man1/aur.1) contains a
general overview, instructions on creating a local repository, and
several examples.

## VERSIONING

|Code changes||
|----|----|
|*Major changes*|Result in a bump of major version (`x.0.0`). Upgrades to a new major version may require a rewrite of interfacing software, or significant changes in workflow.|
|*Minor changes* (incompatible)|Result in a bump of minor version (`x.y.0`). Typically used when application names or command-line options change in a minor way.|
|*Minor changes* (compatible)|Result in a bump of maintenance version (`x.y.z`). Typically used for bug fixes or new, compatible features.|

## TROUBLESHOOTING

See [ISSUE_TEMPLATE.md](ISSUE_TEMPLATE.md). For informal discussion, see the
`#aurutils` channel on [Libera Chat](https://libera.chat/).
  
