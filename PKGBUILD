pkgname=aurutils-git
pkgver=0.8.3.r91.g465c119
pkgrel=1
pkgdesc='helper tools for the aur'
arch=('any')
url=https://github.com/AladW/aurutils
license=('ISC')
source=("git+$url")
md5sums=('SKIP')
conflicts=('aurutils')
provides=('aurutils')
depends=('pacman>=5.0' 'git' 'expac-git' 'jshon-git' 'aria2-git'
         'pacutils-git' 'repose-git' 'datamash-git')
checkdepends=('shellcheck')
makedepends=('git')
optdepends=('devtools: build in an nspawn container'
	    'vifm: improved build file interaction')

pkgver() {
  cd aurutils
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/; s/-/./g'
}

check() {
  cd aurutils
  ./make.sh check
}

package() {
  cd aurutils
  ./make.sh install "$pkgdir"
}
