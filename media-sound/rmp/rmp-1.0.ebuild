EAPI=6

inherit  eutils  gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Random Music Player"

SLOT="0"
KEYWORDS="amd64"
S=${WORKDIR}

DISABLE_AUTOFORMATTING="yes"

DEPEND="media-video/mpv"


src_install() {
    dodir /
	cd "${ED}" || die "enter: ${ED}"

    mkdir -p ${ED}/usr/bin/ || die "create dir"
    cat <<EOF >${ED}/usr/bin/rmp
#!/bin/bash
find /home/yyc/Data/mpd/music/ -type f | sort -R  | \
 xargs -d '\n' mpv --player-operation-mode=pseudo-gui \
 --input-ipc-server=/tmp/mpvsocket
EOF
    chmod +x ${ED}/usr/bin/rmp

    mkdir -p ${ED}/usr/share/applications/ || die "create dir"
    cat <<EOF > ${ED}/usr/share/applications/rmp.desktop
[Desktop Entry]
Version=1.0
Name=rmp
Comment=Radom Music Player
Exec=/bin/bash -c "/usr/bin/rmp"
Icon=rhythmbox
Terminal=false
Type=Application
Categories=Multimedia;
MimeType=x-scheme-handler/pt;
X-Desktop-File-Install-Version=0.23

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
