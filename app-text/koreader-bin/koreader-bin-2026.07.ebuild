EAPI=7
inherit gnome2-utils desktop pax-utils unpacker xdg

DESCRIPTION="koreader"
HOMEPAGE="HOMEPAGE"
SRC_URI="https://github.com/koreader/koreader/releases/download/v${PV}/koreader_${PV}-1_amd64.deb"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

S=${WORKDIR}

RESTRICT="strip mirror bindist" # mirror as explained at bug #547372

DEPEND=()
RDEPEND=()
BDEPEND=()

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
