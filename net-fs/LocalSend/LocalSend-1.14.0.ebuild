EAPI=6
inherit  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="localsend-1.14.0"
HOMEPAGE="https://localsend.org/"
SRC_URI="https://github.com/localsend/localsend/releases/download/v${PV}/LocalSend-${PV}-linux-x86-64.deb"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/"
src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	mkdir opt
	mv usr/share/localsend_app opt/
	sed -i 's#Exec=localsend_app#Exec=/opt/localsend_app/localsend_app#g'\
		usr/share/applications/localsend_app.desktop || die "sed fail"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
