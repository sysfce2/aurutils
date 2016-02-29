# aurutils

Collection of small helper tools for use with the Arch User Repository.

## Dependency lists

There are two tools to create ordered dependency lists; aurqueue uses .SRCINFO files, multireq the AUR RPC.

### aurqueue

It is assumed all dependencies are provided on the command-line, and that SRCINFO files are provided for them (in other words, the sources should already be downloaded).
The SRCINFO files are read with an awk parser, which outputs in a format suitable for tsort. It follows PKGBUILD(5), so should work with split packages, though architecture-specific depends are not supported yet. 
Tsort output is then filtered for repository packages (via pacsift), and queried for virtual packages (via expac). awk, pacsift and expac are called at most once, so performance is good (0.5 second for plasma-desktop-git, with 82 AUR dependencies).

### multireq

The RPC equivalent to aurqueue. Unlike aurqueue, single package names are sufficient to retrieve all dependency information. However, as the RPC lacks "Required by" or similar information, several sequential curl calls are needed. As such, it is much slower (6 seconds for plasma-desktop-git). Of course, you could combine it with aurqueue: create the initial list with multireq, clone the sources, and do later dependency checks with aurqueue.

# TODO

+ Write a proper man page, see man-pages(7)
+ aurbuild - build script using repose. Mostly done, but makepkg doesn't play nice.
+ aurclone - clone script
+ revisit multireq sequential curl use
