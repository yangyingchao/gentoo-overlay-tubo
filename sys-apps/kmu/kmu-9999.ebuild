# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit git-r3 eutils  bash-completion-r1

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

EGIT_REPO_URI="https://github.com/yangyingchao/kmu.git"

KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
DESCRIPTION="Utlity to manage keyword/use/mask for Gentoo."
HOMEPAGE="https://github.com/yangyingchao/kmu"

LICENSE="GPL-2 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE=""

# Most lib deps here are related to programs rather than our libs,
# so we rarely need to specify ${MULTILIB_USEDEP}.
RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
    echo $PWD
    mkdir -p build
    cd build
    rm -rf *
    cmake ../
}

src_install() {
    echo $PWD
    mkdir -p "${ED}"/usr/bin/
    cp build/kmu "${ED}"/usr/bin/
}
