EAPI=8
inherit gnome2-utils pax-utils unpacker

DESCRIPTION="control swaynag via keyboard shortcuts"
HOMEPAGE="https://github.com/b0o/swaynagmode"
SRC_URI="https://github.com/b0o/swaynagmode/archive/refs/tags/v${PV}.tar.gz -> swaynagmode-0.2.1.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="gui-wm/sway"
BDEPEND=""

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe swaynagmode
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
