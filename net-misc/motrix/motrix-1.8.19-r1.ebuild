EAPI=7
inherit gnome2-utils desktop pax-utils unpacker xdg

DESCRIPTION="motrix-1.8.19"
HOMEPAGE="HOMEPAGE"
SRC_URI="https://dl.motrix.app/release/Motrix_${PV}_amd64.deb"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

DEPEND=()
RDEPEND=()
BDEPEND=()

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	[ -f usr/share/doc/motrix/changelog.gz ] && rm -rf usr/share/doc/motrix/

	insinto /usr/share/applications
	doins "${FILESDIR}"/motrix.desktop

	pax-mark m "${CHROME_HOME}/chrome"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
