# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-vm-2 prefix versionator

# This URIs need to be updated when bumping!
JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
JCE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html"

# This is a list of archs supported by this update.
# Currently arm comes and goes.
AT_AVAILABLE=( amd64  x64-macos )

if [[ "$(get_version_component_range 4)" == 0 ]] ; then
	S_PV="$(get_version_component_range 1-3)"
else
	MY_PV_EXT="u$(get_version_component_range 4)"
	S_PV="$(get_version_component_range 1-4)"
fi

MY_PV="$(get_version_component_range 2)${MY_PV_EXT}"

AT_x64_macos="jdk-${MY_PV}-macosx-x64.dmg"

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"


unset d

LICENSE="Oracle-BCLA-JavaSE examples? ( BSD )"
SLOT="1.8"
KEYWORDS="~x64-macos"
IUSE="alsa commercial cups derby doc examples +fontconfig headless-awt javafx nsplugin selinux source visualvm"
REQUIRED_USE="javafx? ( alsa fontconfig )"

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

# # NOTES:
# #
# # * cups is dlopened.
# #
# # * libpng is also dlopened but only by libsplashscreen, which isn't
# #   important, so we can exclude that.
# #
# # * We still need to work out the exact AWT and JavaFX dependencies
# #   under MacOS. It doesn't appear to use many, if any, of the
# #   dependencies below.
# #
# RDEPEND="!x64-macos? (
# 		!headless-awt? (
# 			x11-libs/libX11
# 			x11-libs/libXext
# 			x11-libs/libXi
# 			x11-libs/libXrender
# 			x11-libs/libXtst
# 		)
# 		javafx? (
# 			dev-libs/glib:2
# 			dev-libs/libxml2:2
# 			dev-libs/libxslt
# 			media-libs/freetype:2
# 			x11-libs/cairo
# 			x11-libs/gtk+:2
# 			x11-libs/libX11
# 			x11-libs/libXtst
# 			x11-libs/libXxf86vm
# 			x11-libs/pango
# 			virtual/opengl
# 		)
# 	)
# 	alsa? ( media-libs/alsa-lib )
# 	cups? ( net-print/cups )
# 	doc? ( dev-java/java-sdk-docs:${SLOT} )
# 	fontconfig? ( media-libs/fontconfig:1.0 )
# 	!prefix? ( sys-libs/glibc:* )
# 	selinux? ( sec-policy/selinux-java )"

# DEPEND="""app-arch/zip
# 	examples? ( x64-macos? ( app-arch/unzip ) )"

S="${WORKDIR}"

check_tarballs_available() {
    echo "Skip..."
}

pkg_nofetch() {
    echo "Skip..."
}

src_unpack() {
    echo "Skip..."
}

src_prepare() {
    default
}

src_install() {
    local ddest="${ED}/usr/bin"
    mkdir -p $ddest && cd $ddest && ln -sf  /Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/bin/* .
}

