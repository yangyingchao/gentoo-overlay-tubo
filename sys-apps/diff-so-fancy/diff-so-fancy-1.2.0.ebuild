# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5


inherit bash-completion-r1 unpacker

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/so-fancy/diff-so-fancy"
SRC_URI="https://github.com/so-fancy/diff-so-fancy/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"


LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64"

DSFROOT=${ED}/usr/share/${PN}-${PV}

# Not all tests pass. Need investigation.

pkg_setup() {
	:
}

src_compile() {
	:
}

src_install() {
    mkdir -p ${DSFROOT}
    echo ${DSFROOT}
    mv * ${DSFROOT}/

    echo "PWD: ${PWD}"
    echo "---: ${DSFROOT}"

    mkdir ${ED}/usr/bin
    cd ${ED}/usr/bin && ln -sf ../share/${PN}-${PV}/diff-so-fancy .
}
