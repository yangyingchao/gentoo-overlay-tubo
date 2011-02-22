
EAPI=7

inherit flag-o-matic meson desktop xdg-utils

SLOT=0

KEYWORDS="amd64"

DESCRIPTION="Wayland Overlay Bar."
HOMEPAGE="https://github.com/francma/wob"

LICENSE="MIT"
IUSE="+wayland"

SRC_URI="https://github.com/francma/wob/releases/download/${PV}/wob-${PV}.tar.gz"

RDEPEND="dev-libs/wayland dev-libs/inih"

DEPEND="${RDEPEND}"

BDEPEND="
dev-util/meson
dev-util/ninja
"

src_configure() {
	local emesonargs=(
        --buildtype=release
        -Dman-pages=enabled
    )
    meson_src_configure
}

src_compile() {
    meson_src_compile
}


src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
