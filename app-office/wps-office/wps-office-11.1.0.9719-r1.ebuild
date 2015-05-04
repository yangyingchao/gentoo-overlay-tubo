# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

EAPI="5"

inherit  eutils multilib  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="WPS for linux"
HOMEPAGE="http://wps-community.org/downloads"

MY_P="${PN}_${PV}"
BUILD="${PV/*.}"

SRC_URI="https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${BUILD}/${MY_P}.XA_amd64.deb"
SRC_URI="https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/9719/wps-office_11.1.0.9719_amd64.deb"

LICENSE="WPS"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

src_install() {
    dodir /
	cd "${ED}" || die
	unpacker
}

pkg_postinst() {
    gnome2_icon_cache_update
    xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
