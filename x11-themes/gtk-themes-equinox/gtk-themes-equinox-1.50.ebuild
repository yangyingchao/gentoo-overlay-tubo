# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-aurora/gtk-engines-aurora-1.5.1.ebuild,v 1.4 2010/01/06 19:39:50 fauli Exp $

EAPI=2
inherit versionator

DESCRIPTION="Aurora GTK+ Theme"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=140449"
SRC_URI="http://gnome-look.org/CONTENT/content-files/140449-equinox-themes-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=x11-themes/gtk-engines-equinox-1.50"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/equinox-${PV}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
}

src_configure() {
    echo "configure finished."
}

src_install() {
    echo "PWD $PWD"
    mkdir -p "${D}/usr/share/themes"

    cp -R * "${D}/usr/share/themes/" || die "Install failed!"
}
