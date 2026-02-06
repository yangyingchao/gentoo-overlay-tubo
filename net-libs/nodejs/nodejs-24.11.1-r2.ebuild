# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CONFIG_CHECK="~ADVISE_SYSCALLS"
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit bash-completion-r1 flag-o-matic linux-info ninja-utils pax-utils python-any-r1 toolchain-funcs xdg-utils

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT npm? ( Artistic-2 )"

SRC_URI="https://nodejs.org/dist/v${PV}/node-v${PV}-linux-x64.tar.xz -> ${P}.tar.xz"
KEYWORDS="-* amd64"
SLOT="0"

S="${WORKDIR}/node-v${PV}-linux-x64"

IUSE="corepack cpu_flags_x86_sse2 debug doc +icu +inspector lto npm pax-kernel +snapshot +ssl +system-icu +system-ssl test"

RDEPEND=">=app-arch/brotli-1.1.0:=
	dev-db/sqlite:3
	>=dev-cpp/ada-3.3.0:=
	>=dev-cpp/simdutf-7.3.4:=
	>=dev-libs/libuv-1.51.0:=
	>=dev-libs/simdjson-4.0.7:=
	>=net-dns/c-ares-1.34.5:=
	virtual/zlib:=
	>=dev-libs/icu-73:=
	>=dev-libs/openssl-3.5.4:0=
	sys-devel/gcc:*
"

DEPEND="${RDEPEND}"

src_install(){
	# Install Node
	dobin "${S}"/bin/node
	# Libraries
	insinto "/usr/lib" &&
		doins -r "${S}"/lib/* ||
		die "Error installing libraries."

	# FIX: Those symlinks are broken due to wrong permissions, set by our friend, portage. Thank you portage.
	# I'll figure it out soon.
	dosym "/usr/lib/node_modules/corepack/dist/corepack.js" "/usr/bin/corepack"
	dosym "/usr/lib/node_modules/npm/bin/npm-cli.js" "/usr/bin/npm"
	dosym "/usr/lib/node_modules/npm/bin/npx-cli.js" "/usr/bin/npx"

	doheader -r "${S}"/include/*
	default

	if use doc; then
		dodoc -r "${S}"/share/doc/*
		doman "${S}"/share/man/man1/node.1
		# NPM
		doman "${S}"/lib/node_modules/npm/man{1,5,7}/*
	fi
}
