pkgname=aurutils-git
pkgver=r20.9fafeb0
pkgrel=1
pkgdesc='AUR helpers tools'
arch=('any')
url=https://github.com/AladW/aurutils
license=('ISC')
source=("git+$url")
depends=('pacman>=5.0')
makedepends=('git')
optdepends=('repose-git: aurbuild'
            'powerpill: aurbuild'
            'jshon: multireq'
            'pacutils-git: aurqueue'
            'expac: aurqueue'
            'git: aurclone'
            'aria2: aursearch')

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}    

package() {
    cd aurutils
    install -d "$pkgdir"/usr/bin
    install -m755 * "$pkgdir"/usr/bin
}

md5sums=('SKIP')
