# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

EAPI="2"
DESCRIPTION="gdm-themes-arc-colors-2.7.ebuild"
DOCS="AUTHORS ChangeLog NEWS README TODO"
HOMEPAGE="http://www.bukengnikengshui.com/(joke)"
IUSE="doc"
KEYWORDS="amd64 x86"
LICENSE="LGPL-2"
SLOT="0"
SRC_URI="http://gnome-colors.googlecode.com/files/arc-colors-${PV}.tar.gz"

src_configure(){
    echo "Done."
}

src_compile(){
    emake
}

src_install() {
    echo "PWD: $PWD"
    cd "arc-colors-${PV}"
    emake DESTDIR="${D}" install || die "Failed to install"
}
