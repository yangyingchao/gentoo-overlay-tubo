# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg unpacker

DESCRIPTION="Ebook management application"
HOMEPAGE="https://calibre-ebook.com/"
SRC_URI="https://download.calibre-ebook.com/${PV}/calibre-${PV}-x86_64.txz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ~x86"
SLOT="0"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	dodir /opt/calibre-${PV}
	cd ${ED}/opt/calibre-${PV} || die
	unpacker

	insinto /usr/share/applications
	cat <<-EOF > calibre.desktop
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=Calibre
Comment=Calibre
Exec=/opt/calibre-${PV}/calibre
Icon=/opt/calibre-${PV}/resources/content-server/calibre.png
Terminal=false
Type=Application
Categories=Application;Offce;
GenericName[POSIX]=
EOF
	doins calibre.desktop
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
