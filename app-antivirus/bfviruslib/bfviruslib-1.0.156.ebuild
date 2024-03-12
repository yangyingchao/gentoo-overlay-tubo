
EAPI=6
inherit  eutils gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="bfruntime-1.1.168"
HOMEPAGE="HOMEPAGE"
SRC_URI="/home/yyc/Downloads/360/bifang_tmp/team/360/bfviruslib_1.0.156-1_amd64.deb"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}

src_install() {
	pwd
	ls -al
	dodir /
	cp -aRfv * "${ED}"/ || die
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
