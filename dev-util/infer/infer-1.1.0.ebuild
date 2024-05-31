# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Static analysis tool for Java, C++, Objective-C, and C"
HOMEPAGE="https://github.com/facebook/infer"
SRC_URI="https://github.com/facebook/infer/releases/download/v${PV}/infer-linux64-v${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	dodir "/opt"
	cd "${ED}/opt" || die

	unpacker

	dodir /usr/bin
	cd ${ED}/usr/bin/
	while IFS= read -r -d '' fn; do
		bn=${fn##*/}
		dosym -r "/opt/infer-linux64-v${PV}/lib/infer/infer/bin/$bn" "/usr/bin/$bn" || die "sym"
	done < <(find "${ED}/opt/infer-linux64-v${PV}/lib/infer/infer/bin/" -type f -print0 -o -type l -print0)
}
