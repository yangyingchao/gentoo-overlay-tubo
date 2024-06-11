EAPI=6
inherit gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="bfruntime-1.1.168"
HOMEPAGE="HOMEPAGE"
SRC_URI="/home/yyc/Downloads/360/bifang_tmp/team/360/bfruntime_1.1.168-1_amd64.deb"
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
	mv usr/lib/x86_64-linux-gnu usr/lib64
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
