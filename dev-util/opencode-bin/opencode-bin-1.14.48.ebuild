# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"

GITHUB_BASE="https://github.com/anomalyco/opencode/releases/download/v${PV}"
SRC_URI="${GITHUB_BASE}/opencode-linux-x64.tar.gz -> ${P}-amd64.tar.gz"
KEYWORDS="amd64 ~arm64"

S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
RESTRICT="mirror strip"

[[ ${PV} == 9999 ]] && BDEPEND+=" net-misc/curl"

QA_PREBUILT="usr/bin/opencode"

src_unpack() {
	default_src_unpack
}

src_install() {
	dobin opencode
}
