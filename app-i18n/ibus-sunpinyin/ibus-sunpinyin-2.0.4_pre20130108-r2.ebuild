# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-sunpinyin/ibus-sunpinyin-2.0.4_pre20130108-r1.ebuild,v 1.1 2013/01/31 10:23:45 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
PYTHON_DEPEND="2:2.5"
inherit eutils scons-utils python-single-r1

DESCRIPTION="The SunPinYin IMEngine for IBus Framework"
HOMEPAGE="https://sunpinyin.googlecode.com/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/sunpinyin-${PV}.tar.xz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+nls"

RDEPEND="app-i18n/ibus
    ${PYTHON_DEPS}
	~app-i18n/sunpinyin-${PV}:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	default
	mv "${WORKDIR}/sunpinyin-${PV}" "${S}" || die
}

pkg_setup() {
    python-single-r1_pkg_setup
    echo ${PYTHON}
}

src_prepare() {
	# Patches needed for prefix support
	epatch "${FILESDIR}"/tb_fix.patch
}

src_configure() {
	tc-export CXX
	myesconsargs=(
		--prefix="${EPREFIX}"/usr
		--libexecdir="${EPREFIX}"/usr/libexec
	)
}

src_compile() {
	pushd "${S}"/wrapper/ibus
	escons
	popd
}

src_install() {
	pushd "${S}"/wrapper/ibus
	escons --install-sandbox="${ED}" install
	popd
}

