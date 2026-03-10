# Maintainer: GhostKellz <ghost@ghostkellz.sh>
pkgname=proton-nv
pkgver=1.0.0
pkgrel=1
pkgdesc="NVIDIA-optimized Proton fork for RTX 40/50 + Open Kernel Module 595+"
arch=('x86_64')
url="https://github.com/ghostkellz/proton-NV"
license=('custom:Valve')
depends=('steam')
makedepends=(
    'git'
    'meson'
    'ninja'
    'gcc'
    'mingw-w64-gcc'
    'wine'
    'glslang'
    'ccache'
)
optdepends=(
    'nvproton: Game launcher with profiles'
    'nvshader: Shader cache pre-warming'
    'nvlatency: Reflex integration'
)
provides=('proton')
install=proton-nv.install
source=("$pkgname-$pkgver.tar.gz::$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')
options=('!strip' '!debug')

build() {
    cd "$pkgname-$pkgver"
    ./configure.sh --build-name=Proton-NV
    make
}

package() {
    cd "$pkgname-$pkgver"

    # Install to Steam compatibility tools
    install -dm755 "$pkgdir/usr/share/steam/compatibilitytools.d"
    cp -r dist/Proton-NV-* "$pkgdir/usr/share/steam/compatibilitytools.d/"

    # Symlink to user directory (post_install handles user copy)
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
