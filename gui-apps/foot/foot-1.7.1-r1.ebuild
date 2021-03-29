
EAPI=7

inherit flag-o-matic meson desktop xdg-utils

SLOT=0

KEYWORDS="amd64"

DESCRIPTION="The fast, lightweight and minimalistic Wayland terminal emulator."
HOMEPAGE="https://codeberg.org/dnkl/foot"

LICENSE="MIT"
IUSE="+wayland +xft +pgo"

PV_TLLIST=1.0.4
PV_FCFT=2.3.2
SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz -> foot-${PV}.tar.gz
https://codeberg.org/dnkl/tllist/archive/${PV_TLLIST}.tar.gz -> tllist-${PV_TLLIST}.tar.gz
https://codeberg.org/dnkl/fcft/archive/${PV_FCFT}.tar.gz -> fcft-${PV_FCFT}.tar.gz
"
S="${WORKDIR}/foot"

RDEPEND="dev-libs/wayland
x11-libs/libxkbcommon
x11-libs/pixman
media-libs/fontconfig
media-libs/freetype
"

DEPEND="${RDEPEND}"

BDEPEND="
dev-util/meson
dev-util/ninja
"
PATCHES=("${FILESDIR}/426.patch")

src_prepare() {
    mkdir -p subprojects
    pushd subprojects
    cd subprojects
    unpack ${DISTDIR}/tllist-${PV_TLLIST}.tar.gz
    unpack ${DISTDIR}/fcft-${PV_FCFT}.tar.gz
    popd
    default
}

src_configure() {
    export CFLAGS="$CFLAGS -O3 -march=native  -Wno-missing-profile"
	local emesonargs=(
        --buildtype=release
        -Dime=true
        -Db_lto=true
    )

    meson_src_configure
}

src_compile() {
    meson_src_compile
    export CFLAGS="$CFLAGS -O3 -march=native  -Wno-missing-profile"

    if use pgo; then
        echo "PWD: ${PWD}"
        cd ${BUILD_DIR} || exit 1
        meson configure -Db_pgo=generate
        ninja

        tmp_file=$(mktemp)
        ${WORKDIR}/foot/scripts/generate-alt-random-writes.py \
          --attr-bold \
          --attr-italic \
          --attr-underline \
          --colors-256 \
          --colors-bright \
          --colors-regular \
          --colors-rgb \
          --cols=135 \
          --rows=67 \
          --scroll \
          --scroll-region \
          --sixe \
          ${tmp_file} || die "??"
        ./pgo ${tmp_file} ${tmp_file} ${tmp_file} || die "???"
        rm ${tmp_file}

        meson configure -Db_pgo=use

        ninja
    fi
}


src_install() {
	meson_src_install
}


pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
