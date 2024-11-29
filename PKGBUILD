pkgbase=endpoint
pkgname=endpoint
pkgver=0.1
pkgrel=1
epoch=1
pkgdesc="Test API endpoints"
arch=(x86_64)
depends=(
  glib2
  gtk4
  gtksourceview5
  libsoup3
  json-glib
)
makedepends=(
  git
  meson
  vala
  blueprint-compiler
)
source=("git+https://github.com/ydalton/endpoint")
sha256sums=('SKIP')

prepare() {
  cd $pkgname
}

build() {
  arch-meson $pkgname build
  meson compile -C build
}

package() {
  meson install -C build --destdir "$pkgdir"
}
