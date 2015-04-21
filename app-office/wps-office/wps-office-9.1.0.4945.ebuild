# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

EAPI="5"



inherit readme.gentoo chromium eutils multilib pax-utils unpacker

DESCRIPTION="WPS for linux"
HOMEPAGE="http://kdl.cc.ksosoft.com"

if [[ ${PN} == google-chrome ]]; then
	MY_PN=${PN}-stable
else
	MY_PN=${PN}
fi

MY_P="${MY_PN}_${PV/_p/-}"

SRC_URI="http://kdl.cc.ksosoft.com/wps-community/download/a16/${MY_P}~a16p3_i386.deb"

LICENSE="WPS"
SLOT="0"
KEYWORDS="-* amd64 x86"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

RDEPEND="media-libs/libpng:1.2"

src_install() {
	insinto /
	doins -r opt usr etc
    find "${ED}" -type f -name "wps" -exec chmod 755 {} \;
    find "${ED}" -type f -name "wpp" -exec chmod 755 {} \;
}

pkg_postinst() {
	local lib libdir
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
