# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

MY_PV="$(ver_cut 4)"

DESCRIPTION="WPS Office is an office productivity suite, Here is the Chinese version"
HOMEPAGE="https://linux.wps.cn/#"

KEYWORDS="-* amd64"
SRC_URI="https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${MY_PV}/${PN}_${PV}_amd64.deb"

SLOT="0"
RESTRICT="strip mirror bindist" # mirror as explained at bug #547372
LICENSE="WPS-EULA"
IUSE="big-endian systemd"
REQUIRED_USE="mips? ( !big-endian )"

# Deps got from this (listed in order):
# rpm -qpR wps-office-10.1.0.5707-1.a21.x86_64.rpm
# ldd /opt/kingsoft/wps-office/office6/wps
# ldd /opt/kingsoft/wps-office/office6/wpp
RDEPEND="
	app-arch/bzip2:0
	app-arch/lz4
	app-arch/xz-utils
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	dev-libs/libpcre:3
	media-libs/flac
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/tiff-compat:4
	media-sound/pulseaudio
	net-libs/libasyncns
	net-print/cups
	sys-apps/attr
	sys-apps/dbus
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	sys-libs/libcap
	sys-libs/zlib:0
	virtual/glu
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,mime,templates}

	insinto /opt/kingsoft/wps-office
	use systemd || { rm "${S}"/opt/kingsoft/wps-office/office6/libdbus-1.so* || die ; }
	rm "${S}"/opt/kingsoft/wps-office/office6/libstdc++.so* || die
	rm "${S}"/opt/kingsoft/wps-office/office6/transerr || die
	rm "${S}"/opt/kingsoft/wps-office/office6/wpscloudsvr || die
	doins -r "${S}"/opt/kingsoft/wps-office/{office6,templates}

	fperms 0755 /opt/kingsoft/wps-office/office6/{wps,wpp,et,wpspdf,wpsoffice,promecefpluginhost,ksolaunch}

	# install freetype to fix messes on bold fonts...
	local freetype=freetype-2.13.0-1
	local freetype_tar=${freetype}.gpkg.tar
	local freetype_path=/var/cache/distfiles/${freetype_tar}
	if [ ! -f "${freetype_path}" ]; then
		wget -K -O "${freetype_path}" \
			 https://mirrors.163.com/gentoo/releases/amd64/binpackages/17.1/x86-64/media-libs/freetype/${freetype_tar}
	fi

	[ -f "${freetype_path}" ] || die "Failed to download pkg: ${freetype_tar}"

	cp "${freetype_path}" .
	tar xf ${freetype_tar}
	cd ${freetype} || die "failed to change directory: ${PWD}/${freetype}"
	tar xjf image.tar.bz2 || die "decompress image"
	cp image/usr/lib64/*.so* "${S}"/opt/kingsoft/wps-office/office6/
}
