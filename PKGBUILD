pkgname=aurutils-git
pkgver=r99.20e3730
pkgrel=2
pkgdesc='AUR helpers tools'
arch=('any')
url=https://github.com/AladW/aurutils
license=('ISC')
source=("git+$url")
depends=('pacman>=5.0')
makedepends=('git')
optdepends=('repose-git: aurbuild'
            'powerpill: aurbuild'
            'jshon: aurchain'
            'pacutils-git: aurqueue, aurbuild'
            'expac: aurqueue'
            'git: aurclone'
            'aria2: aursearch'
            'vifm: aurbob')

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}    

package() {
    cd aurutils
    install -d "$pkgdir"/usr/{bin,share{,/licenses}/aurutils}
    install -m755 ./aur* -t "$pkgdir"/usr/bin
    install -m644 LICENSE -t "$pkgdir"/usr/share/licenses/aurutils
}

md5sums=('SKIP')
