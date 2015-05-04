# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Draw UML diagrams using a simple and human readable text description"
HOMEPAGE="http://plantuml.com"
SRC_URI="https://nchc.dl.sourceforge.net/project/plantuml/${PV}/plantuml.${PV}.jar"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"

DEPEND=">=virtual/jdk-1.7"

RDEPEND=">=media-gfx/graphviz-2.26.3"

EANT_BUILD_TARGET="dist"

src_unpack() {
    echo "skip: ${A} ==> ${S}"
    mkdir -p ${S}
}

src_install() {
    local INSTALL_DIR=/usr/share/plantuml/lib
    dodir ${INSTALL_DIR}
    echo "DIR: ${INSTALL_DIR}"
    cp ${DISTDIR}/plantuml.${PV}.jar ${ED}/${INSTALL_DIR}/plantuml.jar
}
