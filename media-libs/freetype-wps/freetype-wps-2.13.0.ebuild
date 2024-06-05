# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="High-quality and portable font engine"
HOMEPAGE="https://www.freetype.org/"

PN="freetype"
P="${PN}-${PV}"

S="${WORKDIR}/${PN}-${PV}"

SRC_URI="https://downloads.sourceforge.net/freetype/${P/_/}.tar.xz"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="2"
IUSE="X +adobe-cff brotli bzip2 +cleartype-hinting debug doc fontforge harfbuzz +png static-libs svg utils"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	echo "SKIP"..
}

src_compile () {
	echo "SKIP"..
}

src_install() {
	meson setup meson_build_release --buildtype=release
	cd meson_build_release
	ninja -k 8

	insinto /opt/kingsoft/wps-office/office6/
	doins -r libfreetype.so libfreetype.so.6 libfreetype.so.6.19.0
}
