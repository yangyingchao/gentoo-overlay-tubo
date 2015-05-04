EAPI=6

inherit  eutils multilib  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Ebook management application"
HOMEPAGE="https://calibre-ebook.com/"

MY_P="calibre-${PV}"

SRC_URI="https://download.calibre-ebook.com/${PV}/${MY_P}-x86_64.txz"
SLOT="0"
KEYWORDS="amd64"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

src_install() {
    dodir /
	cd "${ED}" || die
    mkdir -p opt/calibre
    cd opt/calibre
	unpacker

    mkdir -p ${ED}/usr/share/applications/
    cat <<EOF >${ED}/usr/share/applications/calibre.desktop
[Desktop Entry]
Type=Application
Name=Calibre
GenericName=Calibre
Icon=/opt/calibre/resources/content-server/calibre.png
Exec=/opt/calibre/calibre
Terminal=false

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
