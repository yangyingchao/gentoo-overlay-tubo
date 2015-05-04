EAPI=6


inherit  eutils gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="QQ Linux version"
HOMEPAGE="https://im.qq.com/linuxqq/index.html"

MY_P="${PN}_${PV}-b1-1024"
SRC_URI="https://qd.myapp.com/myapp/qqteam/linuxQQ/${MY_P}_amd64.deb"

KEYWORDS="amd64"

SLOT="0"
KEYWORDS="amd64"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

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
