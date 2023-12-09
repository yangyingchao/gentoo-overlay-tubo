EAPI=7

inherit flag-o-matic meson desktop xdg-utils

SLOT=0

KEYWORDS="amd64"

DESCRIPTION="Application launcher for wlroots based Wayland compositors"
HOMEPAGE="https://codeberg.org/dnkl/fnott"

LICENSE="MIT"
IUSE=""

SRC_URI="https://codeberg.org/dnkl/fnott/archive/${PV}.tar.gz -> fnott-${PV}.tar.gz"
S="${WORKDIR}/fnott"

RDEPEND="dev-libs/wayland
dev-libs/json-c
media-libs/fontconfig
media-libs/freetype
dev-libs/tllist
media-libs/fcft
"

DEPEND="${RDEPEND}"

BDEPEND="
dev-util/meson
dev-util/ninja
"

src_configure() {
	local emesonargs=(
		--buildtype=release
	)
	sed -i '/fnott.desktop/d' meson.build
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
