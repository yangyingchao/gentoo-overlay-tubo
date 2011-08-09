# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

DESCRIPTION="iptux-0.5.ebuild"
DOCS="AUTHORS ChangeLog NEWS README TODO"
EAPI="2"
HOMEPAGE="http://www.bukengnikengshui.com/(joke)"
IUSE="doc"
KEYWORDS="amd64 x86"
LICENSE="LGPL-2"
SLOT="0"
SRC_URI="http://abc.org/${P}.tar.gz"

src_configure(){

    local myconf

    myconf="${myconf} --prefix=/usr --sysconfdir=/etc"

   econf ${myconf} || die "Config failed."


}

src_compile(){
    emake -j3 || die "Make failed."
}

src_install() {
        emake DESTDIR="${D}" install || die "Failed to install"
}
