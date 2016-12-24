#!/bin/bash
set -e

if (($# != 1)); then
    exit 1
else
    declare -r testrepo1=$1
fi

# cache/checksum test
mkdir test-random
cat > test-random/PKGBUILD <<'EOF'
pkgname=test-random
pkgver=1
pkgrel=1
pkgdesc="description"
arch=('any')
url="http://example.com"
license=('GPL')

package() {
    mkdir -p "$pkgdir"/var/tmp/
    dd if=/dev/urandom of="$pkgdir"/var/tmp/random bs=1M count=4
}
EOF

echo test-random > argfile

i=0
while [ $((i < 10)) -eq 1 ]; do
    aurbuild -d "$testrepo1" -a ./argfile -- -crsf
    sudo pacman -S --noconfirm test-random
    i=$((i +1))
done

sudo pacman -R --noconfirm test-random

