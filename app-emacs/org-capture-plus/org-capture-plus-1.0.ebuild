EAPI=6

inherit  eutils multilib  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Org capture plus"
HOMEPAGE="${2:HOMEPAGE}"

SRC_URI="${3:SRC}"

SLOT="0"
KEYWORDS="amd64"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

src_install() {
	cat > "${ED}/usr/share/applications/org-protocol.desktop" << EOF
[Desktop Entry]
Name=org-protocol
Exec=emacsclient %u
Type=Application
Terminal=false
Categories=System;
MimeType=x-scheme-handler/org-protocol;
EOF
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
