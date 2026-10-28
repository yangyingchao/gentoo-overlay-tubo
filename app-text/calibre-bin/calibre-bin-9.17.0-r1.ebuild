# Copyright 1999-2026 Gentoo Authors
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
INSTALL_DIR=/opt/calibre-${PV}

src_unpack() {
	:
}

src_install() {
	dodir "${INSTALL_DIR}"
	cd "${ED}/${INSTALL_DIR}" || die
	dosym "${INSTALL_DIR}" "/opt/calibre"
	unpacker

	insinto /usr/share/applications
	doins "${FILESDIR}"/calibre.desktop
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
