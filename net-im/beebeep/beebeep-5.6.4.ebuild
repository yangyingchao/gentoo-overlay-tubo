EAPI=6


inherit  eutils multilib  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="A free office messenger."
HOMEPAGE="https://www.beebeep.net/"

SRC_URI=" https://liquidtelecom.dl.sourceforge.net/project/beebeep/Sources/beebeep-code-${PV}.zip"

SLOT="0"
KEYWORDS="amd64"
S=${WORKDIR}

src_configure() {
    cd beebeep-code-r1160/src && qmake || die "Configure fail."
    cd ../plugins && qmake || die "Configure fail."
}

src_compile() {
    cd beebeep-code-r1160/src || die "chdir"
    emake ||  die "compile fail."
    cd ../plugins && emake || die "compile plugins failed."
}

src_install() {
    echo PWD: $PWD

    cd beebeep-code-r1160/scripts || die "change dir"

    BEEBEEP_QT_VERSION=qt5
    BEEBEEP_ARCH_TYPE=arm64

    . ./inc_linux_package.txt

    [ -d beebeep-${PV}-qt5-arm64 ] || die "folder not exists??"

    pkg=${PWD}/beebeep-5.6.4-qt5-arm64

    dodir /
	cd "${ED}" || die

    mkdir opt
    cd opt

    mv ${pkg} beebeep

    mkdir -p ${ED}/usr/share/applications/
    cat <<EOF > ${ED}/usr/share/applications/beebeep.desktop
[Desktop Entry]
Name=BeeBEEP
Comment=Chat over IM.
Exec=/opt/beebeep/beebeep
Icon=/opt/beebeep/beebeep.png
StartupNotify=true
Terminal=false
Type=Application
Categories=Network;InstantMessaging;

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
