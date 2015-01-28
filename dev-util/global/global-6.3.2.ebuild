# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/global/global-6.3.1.ebuild,v 1.6 2014/11/05 19:14:18 floppym Exp $

EAPI="5"

inherit autotools elisp-common eutils

DESCRIPTION="GNU Global is a tag system to find the locations of a specified object in various sources"
HOMEPAGE="http://www.gnu.org/software/global/global.html"
SRC_URI="http://tamacom.com/global/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="doc emacs vim +ctags"

RDEPEND="|| ( dev-libs/libltdl:0 sys-devel/libtool:2 )
    dev-util/ctags
	sys-libs/ncurses
	emacs? ( virtual/emacs )
	vim? ( || ( app-editors/vim app-editors/gvim ) )"
DEPEND="${DEPEND}
	doc? ( app-text/texi2html sys-apps/texinfo )"

SITEFILE="50gtags-gentoo.el"

DOC_CONTENTS="
You may need to update environment variables to use ctags,
adding following lines into your bash configuration:


if [ -r $PWD/.globalrc ]; then
    GTAGSCONF=$PWD/.globalrc
elif [ -r $HOME/.globalrc ]; then
    GTAGSCONF=$HOME/.globalrc
elif [ -r /usr/local/share/gtags/gtags.conf ]; then
    GTAGSCONF=/usr/local/share/gtags/gtags.conf
fi

export GTAGSCONF
export export GTAGSLABEL=exuberant-ctags
"
src_prepare() {
	epatch "${FILESDIR}/${PN}-6.2.9-tinfo.patch"
    cp "${FILESDIR}/99gtags" .
	eautoreconf
}

src_configure() {
	econf "$(use_with emacs lispdir "${SITELISP}/${PN}")" \
          "--with-exuberant-ctags=/usr/bin/exuberant-ctags"
}

src_compile() {
	if use doc; then
		texi2pdf -q -o doc/global.pdf doc/global.texi
		texi2html -o doc/global.html doc/global.texi
	fi

	if use emacs; then
		elisp-compile *.el
	fi

	emake
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		dohtml doc/global.html
		# doc/global.pdf is generated if tex executable (e.g. /usr/bin/tex) is available.
		[[ -f doc/global.pdf ]] && dodoc doc/global.pdf
	fi

	dodoc AUTHORS FAQ NEWS README THANKS

	insinto /etc
	doins gtags.conf

    insinto /etc/env.d
    doins 99gtags

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins gtags.vim
	fi

	if use emacs; then
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	prune_libtool_files
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
