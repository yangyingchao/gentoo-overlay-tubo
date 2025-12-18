# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

# https://apt.metasploit.com/
SRC_URI="https://apt.metasploit.com/pool/main/m/metasploit-framework/metasploit-framework_6.4.103~20251213055703~1rapid7-1_amd64.deb -> ${P}.deb"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
SLOT="0"

S="${WORKDIR}"

DESCRIPTION="Advanced framework for developing, testing, and using vulnerability exploit code"
HOMEPAGE="http://www.metasploit.org/"
LICENSE="BSD"
IUSE="test"

RESTRICT="strip bindist binchecks fixlafiles primaryuri"

COMMON_DEPEND="
	app-arch/xz-utils
	dev-libs/libffi
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/openssl
	net-analyzer/nmap
	net-libs/libpcap
	sys-libs/zlib"
RDEPEND+=" ${COMMON_DEPEND}"
DEPEND+=" ${COMMON_DEPEND}"

src_install() {
	insinto /opt/metasploit-framework
	doins -r "${S}"/opt/metasploit-framework/*

	fperms 0755 /opt/metasploit-framework/bin/*
	fperms 0755 /opt/metasploit-framework/embedded/bin/*

	mkdir -p "${D}"/usr/bin
	pushd "${D}"/usr/bin || die "??"
	for fn in "${D}"/opt/metasploit-framework/bin/* ; do
		dosym ../../opt/metasploit-framework/bin/"${fn##*/}" "usr/bin/${fn##*/}"
	done

	insinto /opt/metasploit-framework/embedded/share/terminfo/f/
	if [[ -f /usr/share/terminfo/f/foot ]]; then
		doins -r /usr/share/terminfo/f/foot*
	fi
}
