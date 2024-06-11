EAPI=6
inherit gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="SecoClient-7.0.2.26"
HOMEPAGE="HOMEPAGE"
SRC_URI="SecoClient-7.0.2.26.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}"
src_install() {
	dodir /
	cd "${ED}" || die
	mkdir -p usr/local/
	pushd usr/local || die
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
