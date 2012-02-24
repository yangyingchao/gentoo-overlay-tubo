# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

DESCRIPTION="A collection of theme, including: gtk-engine, gtk-theme and gdm themes."
DOCS="AUTHORS ChangeLog NEWS README TODO"
EAPI="2"
HOMEPAGE="http://www.bukengnikengshui.com/(joke)"
IUSE="doc"
KEYWORDS="amd64 x86"
LICENSE="LGPL-2"
SLOT="0"


RDEPEND="!gnome-base/gnome
	>=x11-themes/gtk-engines-equinox-1.50
	>=x11-themes/gtk-themes-equinox-1.50
	>=x11-themes/gdm-themes-arc-colors-2.7"
DEPEND="${RDEPEND}"

pkg_postinst () {
	ewarn "Now you can select theme and gdm theme!"
}
