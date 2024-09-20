# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="Keyboard driven and lightweight Wayland notification daemon."
HOMEPAGE="https://codeberg.org/dnkl/fnott"
EGIT_REPO_URI="https://codeberg.org/yangyingchao/fnott.git"
EGIT_BRANCH="yc-hacking"
KEYWORDS="amd64"
LICENSE="MIT ZLIB"
SLOT="0"

RDEPEND="
	dev-libs/wayland
	media-libs/fcft
	media-libs/freetype
	media-libs/libpng
	sys-apps/dbus
	x11-libs/pixman
	media-libs/fontconfig
"
DEPEND="
	${RDEPEND}
	dev-libs/tllist
"
BDEPEND="
	dev-util/wayland-scanner
	>=dev-libs/wayland-protocols-1.32
	app-text/scdoc
"

src_install() {
	local DOCS=( CHANGELOG.md README.md )
	meson_src_install

	rm -r "${ED}"/usr/share/doc/"${PN}" || die
}
