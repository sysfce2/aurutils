#!/bin/dash
set -eux

testrepo1=aurutils-test
testrepo2=aurutils-test-vcs
testroot1=/var/tmp/test-chroot
tmp=$(mktemp -d)

cd "$tmp"

# clear repo
server1=$(pacconf --single Server --repo="$testrepo1")
server1=${server1#*://}
server2=$(pacconf --single Server --repo="$testrepo2")
server2=${server2#*://}
find "$server1" "$server2" -type f \( -name '*.pkg*' -or -name '*.db*' -or -name '*.files*' \) -delete

repo-add "$server1/$testrepo1".db.tar
repo-add "$server2/$testrepo2".db.tar
sudo pacsync "$testrepo1" "$testrepo2"

# chroot test
test -d "$testroot1" && sudo rm -rf "$testroot1"
AURDEST=$tmp aursync --nobuild --noview aurutils-git
printf '%s\n' pacutils aurutils-git > argfile
aurbuild -cd "$testrepo1" -C "$testroot1" -a argfile
aurbuild -cd "$testrepo1" -a argfile
sudo pacsync "$testrepo1"
pacman -Si "$testrepo1"/aurutils-git # Repository move

# package test
aursync -Ln --noview --repo="$testrepo1" python-nikola # Split package
pacman -Si "$testrepo1"/python-nikola
aursync -Ln --noview --repo="$testrepo2" python-nikola # Per-repo versions
pacman -Si "$testrepo2"/python-nikola
aursync -Ln --noview --repo="$testrepo1" libdbusmenu-gtk2-ubuntu # Split package, pkgbase != pkgname
pacman -Si "$testrepo1"/libdbusmenu-gtk2-ubuntu
aursync -Ln --noview --repo="$testrepo1" gimp-plugin-separate+ # Special characters
pacman -Si "$testrepo1"/gimp-plugin-separate+
aursync -Ln --noview --repo="$testrepo1" ros-build-tools # Empty make/depends
pacman -Si "$testrepo1"/ros-build-tools
aursync -Ln --noview --repo="$testrepo2" shaman-git # Special characters - UTF8
pacman -Si "$testrepo2"/shaman-git
aursync -Ln --noview --repo="$testrepo2" aws-cli-git # Complex PKGBUILD
pacman -Si "$testrepo2"/aws-cli-git
aursync -Ln --noview --repo="$testrepo2" openrct2-git # make/depends_arch
pacman -Si "$testrepo2"/openrct2-git
#aursync -Ln --noview --repo="$testrepo2" plasma-git-meta # 100+ depends
#aursync -Ln --noview --repo="$testrepo1" ros-indigo-desktop-full # 250+ depends

# warning messages
aursync --nobuild --noview aura > out.log 2>&1
total=$(grep -ci 'no results' out.log)
test "$total" -eq 5

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

# exact repository match
total1=$(aurcheck -a "$testrepo1" | wc -l)
total2=$(pacman -Slq "$testrepo1" | wc -l)
test "$total1" -eq "$total2"

total1=$(aurcheck -a "$testrepo2" | wc -l)
total2=$(pacman -Slq "$testrepo2" | wc -l)
test "$total1" -eq "$total2"

aurcheck -a "$testrepo1" > out1.log
aurcheck -a "$testrepo2" > out2.log
datamash -W check out1.log
datamash -W check out2.log

# regex search/json merge
aurgrep '.+' > list
total1=$(xargs -a list aursearch -Fr | jq -r '.[]results[].Name' | wc -l)
total2=$(wc -l list)
test "$total1" -eq "$total2"
