EAPI=7
inherit gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="SecoClient-7.0.2.26"
HOMEPAGE="HOMEPAGE"
SRC_URI="SecoClient-7.0.2.26.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
=dev-qt/qtcore-5.15.18
=dev-qt/qtdbus-5.15.18
=dev-qt/qtgui-5.15.18-r1
=dev-qt/qtnetwork-5.15.18
=dev-qt/qtwayland-5.15.18
"
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
