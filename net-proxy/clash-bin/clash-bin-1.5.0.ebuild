# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="An unidentifiable mechanism that helps you bypass GFW"
HOMEPAGE="https://github.com/trojan-gfw/trojan"
SRC_URI="https://github.com/Dreamacro/clash/releases/download/v${PV}/clash-linux-amd64-v${PV}.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="mysql"

RDEPEND="
	>=dev-libs/boost-1.66.0:=
	dev-libs/openssl:0=
	mysql? ( dev-db/mysql-connector-c:= )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
    mkdir -p ${ED}/usr/bin/ || die "create dir"
    mv clash-linux-amd64-v${PV} ${ED}/usr/bin/clash
    chmod +x ${ED}/usr/bin/clash
	systemd_newunit "${FILESDIR}/clash.service" clash.service
}

pkg_postinst() {
	elog "Config with Systemd"
	elog "   systemctl enable clash"
	elog ""
}
