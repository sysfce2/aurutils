pkgname=aurutils-git
pkgver=r166.6c5a1b4
pkgrel=1
pkgdesc='AUR helpers tools'
arch=('any')
url=https://github.com/AladW/aurutils
license=('ISC')
source=("git+$url")
depends=('pacman>=5.0' 'git' 'repose-git' 'jshon' 'pacutils-git' 'expac' 'aria2' 'vifm')
makedepends=('git')
optdepends=('powerpill: aurbuild')
           
pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}    

package() {
    cd aurutils
    install -d "$pkgdir"/usr/{bin,share{/licenses,/doc}/aurutils}

    install -m755 ./aur* -t "$pkgdir"/usr/bin
    install -m644 LICENSE -t "$pkgdir"/usr/share/licenses/aurutils
    install -m644 CREDITS README.md -t "$pkgdir"/usr/share/doc/aurutils
}

md5sums=('SKIP')
