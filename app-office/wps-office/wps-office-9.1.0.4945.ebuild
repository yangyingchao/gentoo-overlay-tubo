# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: ^&^ $

EAPI="5"

DESCRIPTION="WPS for linux"


inherit readme.gentoo chromium eutils multilib pax-utils unpacker

DESCRIPTION="The web browser from Google"
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
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/bitstream-cyberbit
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

Depending on your desktop environment, you may need
to install additional packages to get icons on the Downloads page.

For KDE, the required package is kde-base/oxygen-icons.

For other desktop environments, try one of the following:
- x11-themes/gnome-icon-theme
- x11-themes/tango-icon-theme

Please notice the bundled flash player (PepperFlash).
You can (de)activate all flash plugins via chrome://plugins
"

src_install() {
	insinto /
	doins -r opt usr etc
    find "${ED}" -type f -name "wps" -exec chmod 755 {} \;
    find "${ED}" -type f -name "wpp" -exec chmod 755 {} \;
}

pkg_postinst() {
	local lib libdir
	# for libdir in {,usr/}$(get_libdir); do
	# 	lib=${EROOT}${libdir}/libudev.so.1
	# 	if [[ -e ${lib} ]]; then
	# 		ln -fs "${lib}" "${EROOT}${WPS_HOME}/libudev.so.0"
	# 		break
	# 	fi
	# done
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
