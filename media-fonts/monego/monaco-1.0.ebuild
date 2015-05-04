# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Improved monaco.ttf: add some special characters."
HOMEPAGE="https://github.com/cseelus/monego"
SRC_URI="https://github.com/todylu/monaco.ttf/raw/master/monaco.ttf -> ${P}.ttf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~x86"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_unpack() {
	cp "${DISTDIR}/${A}" "${FONT_S}/${PN}.${FONT_SUFFIX}" || die
}
