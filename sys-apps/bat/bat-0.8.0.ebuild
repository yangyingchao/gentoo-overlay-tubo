# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5


inherit bash-completion-r1 unpacker

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="https://github.com/sharkdp/bat/releases/download/v${PV}/bat_${PV}_amd64.deb"


LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64"

# Not all tests pass. Need investigation.

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "fzf only works on amd64"
}

pkg_setup() {
	:
}

src_unpack() {
    mkdir bat-${PV}
}

src_compile() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker
}
