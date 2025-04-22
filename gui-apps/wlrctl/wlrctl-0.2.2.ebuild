EAPI=8
inherit  meson unpacker

DESCRIPTION="A command line utility for miscellaneous wlroots Wayland extensions"
HOMEPAGE="https://git.sr.ht/~brocellous/wlrctl"
SRC_URI="https://git.sr.ht/~brocellous/wlrctl/archive/v${PV}.tar.gz -> wlrctl-${PV}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
S=${WORKDIR}/${PN}-v${PV}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
}
