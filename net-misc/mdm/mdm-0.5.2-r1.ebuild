# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Open-source download manager written in Rust"
HOMEPAGE="https://github.com/anefzaoui/misterdownloadmanager"
# Distfile name pinned to the upstream product name: it must not follow ${PN}, or a rename
# would orphan the copy already in DISTDIR.
SRC_URI="https://github.com/anefzaoui/misterdownloadmanager/releases/download/v${PV}/MisterDownloadManager-${PV}-linux-x86_64.deb -> misterdownloadmanager-${PV}-amd64.deb"
S="${WORKDIR}"

LICENSE="GPL-3+"
# Bundled assets: Lucide icons (ISC), flag-icons (MIT), DB-IP Lite geo data (CC-BY-4.0),
# Adwaita and Breeze icons (LGPL-3)
LICENSE+=" ISC MIT CC-BY-4.0 LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RESTRICT="strip"

# The GUI dlopen()s its X11/Wayland/GL stack at runtime, so portage cannot record these
# automatically. libEGL.so.1 and libGL.so.1 come from media-libs/libglvnd; the GL driver
# itself (media-libs/mesa or the proprietary one) has to be installed separately.
RDEPEND="
	app-misc/ca-certificates
	dev-libs/wayland
	media-libs/libglvnd
	sys-apps/dbus
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
"

QA_PREBUILT="
	usr/bin/misterdownloadmanager
	usr/bin/misterdownloadmanager-cli
	usr/bin/misterdownloadmanager-mcp
	usr/bin/misterdownloadmanager-nmhost
"

src_install() {
	doins -r *

	rm -rf "${ED}"/usr/share/doc/misterdownloadmanager
	rm -rf "${ED}"/usr/share/misterdownloadmanager

	exeinto /usr/bin
	exeopts -m0755
	doexe usr/bin/*

	dosym -r /usr/bin/misterdownloadmanager-cli /usr/bin/mdm
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
