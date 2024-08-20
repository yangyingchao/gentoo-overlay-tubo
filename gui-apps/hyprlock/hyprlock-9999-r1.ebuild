# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Hyprland's GPU-accelerated screen locking utility"
HOMEPAGE="https://github.com/hyprwm/hyprlock"
KEYWORDS="amd64"
EGIT_REPO_URI="https://github.com/yangyingchao/hyprlock.git"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-libs/hyprlang-0.4.0
	>=gui-libs/hyprutils-0.2.0
	dev-libs/date
	dev-libs/glib:2
	dev-libs/wayland
	media-libs/libglvnd
	media-libs/mesa[opengl]
	sys-libs/pam
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/libdrm
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"
