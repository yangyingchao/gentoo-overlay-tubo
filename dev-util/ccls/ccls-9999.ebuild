EAPI=7


inherit  eutils pax-utils unpacker xdg-utils
inherit git-r3 cmake-utils

DESCRIPTION="Language Server Protocol for C, C++, and Objective-C languages."
HOMEPAGE="https://github.com/MaskRay/ccls"

EGIT_REPO_URI="https://github.com/MaskRay/ccls.git"
EGIT_BRANCH="master"
EGIT_CHECKOUT_DIR="${WORKDIR}/ccls"
EGIT_SUBMODULES=()

SLOT="0"
KEYWORDS="amd64"
S="${EGIT_CHECKOUT_DIR}"

DISABLE_AUTOFORMATTING="yes"

DEPEND="dev-libs/rapidjson
  sys-devel/clang
  sys-devel/llvm"

PATCHES=(
    "${FILESDIR}/dynamic_lib.patch"
)

src_configure() {
    export CC=clang
    export CXX=clang++

    local mycmakeargs=(
        -DCMAKE_VERBOSE_MAKEFILE=OFF
        -DCMAKE_EXPORT_COMPILE_COMMANDS=OFF
        -DUSE_SYSTEM_RAPIDJSON=ON
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
	)

	cmake-utils_src_configure
}
