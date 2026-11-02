# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A fast, keyboard-first file manager for modern Linux desktops"
HOMEPAGE="https://stratafiles.io/"
SRC_URI="https://github.com/lgse/strata/releases/download/v${PV}/${PN}-${PV}-x86_64-unknown-linux-gnu.tar.gz"
S="${WORKDIR}/${PN}-${PV}-x86_64-unknown-linux-gnu"

RESTRICT="strip mirror bindist" # prebuilt binary; mirror as explained at bug #547372

LICENSE="MIT"
# Bundled third-party assets and Rust crate dependencies
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 ISC LGPL-2.0-or-later MPL-2.0 OFL-1.1
	UbuntuFontLicense-1.0 UnRAR Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	gui-libs/gtk:4
	gui-libs/gtksourceview:5
	media-libs/fontconfig
"

src_install() {
	dobin strata

	doicon io.github.lgse.Strata.svg
	domenu io.github.lgse.Strata.desktop

	insinto /usr/share/dbus-1/services
	doins io.github.lgse.Strata.FileManager1.service

	insinto /usr/share/xdg-desktop-portal/portals
	doins portal/strata.portal

	sed "s|@STRATA_EXECUTABLE@|/usr/bin/strata|" \
		portal/org.freedesktop.impl.portal.desktop.strata.service.in \
		> "${T}/org.freedesktop.impl.portal.desktop.strata.service" || die
	insinto /usr/share/dbus-1/services
	doins "${T}/org.freedesktop.impl.portal.desktop.strata.service"

	insinto /etc/xdg/xdg-desktop-portal
	doins portal/portals.conf
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Strata's FileChooser portal backend is enabled system-wide via"
	elog "/etc/xdg/xdg-desktop-portal/portals.conf. A user-level file in"
	elog "~/.config/xdg-desktop-portal/portals.conf overrides it. Restart the"
	elog "portal frontend to activate:"
	elog "  systemctl --user restart xdg-desktop-portal.service"
}

pkg_postrm() {
	xdg_pkg_postrm
}
