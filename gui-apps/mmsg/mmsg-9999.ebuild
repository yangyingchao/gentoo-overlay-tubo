# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Send IPC messages to mango"
HOMEPAGE="https://github.com/DreamMaoMao/mmsg"

EGIT_REPO_URI="https://github.com/DreamMaoMao/mmsg.git"

LICENSE="0BSD"
SLOT="0"
IUSE=""
KEYWORDS="amd64"

BDEPEND="
  gui-wm/mangowc
  dev-util/wayland-scanner
"
RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
}

src_compile() {
	emake
}

src_install() {
	exeinto /usr/bin
	doexe mmsg
}
