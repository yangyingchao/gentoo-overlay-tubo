# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic readme.gentoo-r1 toolchain-funcs

# Very basic ebuild for emacs, without anything but dynamic-loading
# feature. This is required to provide basic editor in TTY. I'll build
# my own emacs from source, with help emacs-dep package...

FULL_VERSION="${PV%%_*}"
S="${WORKDIR}/emacs-${FULL_VERSION}"
SRC_URI="https://alpha.gnu.org/gnu/emacs/pretest/emacs-${PV/_/-}.tar.xz"
SLOT="${PV%%.*}"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="https://www.gnu.org/software/emacs/"

LICENSE="GPL-3+ FDL-1.3+ BSD HPND MIT W3C unicode PSF-2"
IUSE=""

RDEPEND="app-emacs/emacs-common
	sys-libs/ncurses:0="

DEPEND="${RDEPEND}"

BDEPEND="sys-apps/texinfo
	virtual/pkgconfig"

IDEPEND="app-eselect/eselect-emacs"

RDEPEND+=" ${IDEPEND}"

EMACS_SUFFIX="emacs-${SLOT}"
SITEFILE="20${EMACS_SUFFIX}-gentoo.el"

src_prepare() {
	default

	# Fix filename reference in redirected man page
	sed -i -e "/^\\.so/s/etags/&-${EMACS_SUFFIX}/" doc/man/ctags.1 || die

	# libseccomp is detected by configure but doesn't appear to have any
	# effect on the installed image. Suppress it by supplying pkg-config
	# with a wrong library name.
	sed -i -e "/CHECK_MODULES/s/libseccomp/DiSaBlE&/" configure.ac || die

	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	local myconf

	# Prevents e.g. tests interfering with running Emacs.
	unset EMACS_SOCKET_NAME
	einfo "Configuring to build without window system support"
	myconf+=" --without-x --without-pgtk --without-ns"

	econf \
		--program-suffix="-${EMACS_SUFFIX}" \
		--includedir="${EPREFIX}"/usr/include/${EMACS_SUFFIX} \
		--infodir="${EPREFIX}"/usr/share/info/${EMACS_SUFFIX} \
		--localstatedir="${EPREFIX}"/var \
		--enable-locallisppath="${EPREFIX}/etc/emacs:${EPREFIX}${SITELISP}" \
		--without-compress-install \
		--without-hesiod \
		--without-pop \
		--with-file-notification=no \
		--with-pdumper \
		--without-dbus \
		--with-modules \
		--without-gameuser \
		--without-gpm \
		--without-native-compilation \
		--without-json \
		--without-kerberos \
		--without- lcms2 \
		--without-xml2 \
		--without-mailutils \
		--without-selinux \
		--without-sqlite3 \
		--without-tree-sitter \
		${myconf}
}

src_compile() {
	if tc-is-cross-compiler; then
		# Build native tools for compiling lisp etc.
		emake -C "${S}-build" src
		emake lib	   # Cross-compile dependencies first for timestamps
		# Save native build tools in the cross-directory
		cp "${S}-build"/lib-src/make-{docfile,fingerprint} lib-src || die
		# Specify the native Emacs to compile lisp
		emake -C lisp all EMACS="${S}-build/src/emacs"
	fi

	emake
}

src_test() {
	# List .el test files with a comment above listing the exact
	# subtests which caused failure. Elements should begin with a %.
	# e.g. %lisp/gnus/mml-sec-tests.el.
	local exclude_tests=(
		# Reason: not yet known
		# mml-secure-en-decrypt-{1,2,3,4}
		# mml-secure-find-usable-keys-{1,2}
		# mml-secure-key-checks
		# mml-secure-select-preferred-keys-4
		# mml-secure-sign-verify-1
		%lisp/gnus/mml-sec-tests.el

		# Reason: permission denied on /nonexistent
		# (vc-*-bzr only fails if breezy is installed, as they
		# try to access cache dirs under /nonexistent)
		#
		# rmail-undigest-test-multipart-mixed-digest
		# rmail-undigest-test-rfc1153-less-strict-digest
		# rmail-undigest-test-rfc1153-sloppy-digest
		# rmail-undigest-test-rfc934-digest
		# vc-test-bzr02-state
		# vc-test-bzr05-rename-file
		# vc-test-bzr06-version-diff
		# vc-bzr-test-bug9781
		%lisp/mail/undigest-tests.el
		%lisp/vc/vc-tests.el
		%lisp/vc/vc-bzr-tests.el

		# Reason: fails if bubblewrap (bwrap) is installed
		# "bwrap: setting up uid map: Permission denied"
		#
		# bytecomp-tests--dest-mountpoint
		%lisp/emacs-lisp/bytecomp-tests.el
	)

	# See test/README for possible options
	emake \
		EMACS_TEST_VERBOSE=1 \
		EXCLUDE_TESTS="${exclude_tests[*]}" \
		TEST_BACKTRACE_LINE_LENGTH=nil \
		check
}

src_install() {
	emake DESTDIR="${D}" NO_BIN_LINK=t BLESSMAIL_TARGET= install

	mv "${ED}"/usr/bin/{emacs-${FULL_VERSION}-,}${EMACS_SUFFIX} || die
	mv "${ED}"/usr/share/man/man1/{emacs-,}${EMACS_SUFFIX}.1 || die
	mv "${ED}"/usr/share/metainfo/{emacs-,}${EMACS_SUFFIX}.metainfo.xml || die

	# dissuade Portage from removing our dir file #257260
	touch "${ED}"/usr/share/info/${EMACS_SUFFIX}/.keepinfodir
	docompress -x /usr/share/info/${EMACS_SUFFIX}/dir

	# avoid collision between slots, see bug #169033 e.g.
	rm "${ED}"/usr/share/emacs/site-lisp/subdirs.el || die
	rm -rf "${ED}"/usr/share/{applications,icons} || die
	rm -rf "${ED}"/usr/share/glib-2.0 || die #911117
	rm -rf "${ED}/usr/$(get_libdir)/systemd" || die
	rm -rf "${ED}"/var || die

	# remove unused <version>/site-lisp dir
	rm -rf "${ED}"/usr/share/emacs/${FULL_VERSION}/site-lisp || die

	# remove COPYING file (except for etc/COPYING used by describe-copying)
	rm "${ED}"/usr/share/emacs/${FULL_VERSION}/lisp/COPYING || die

	local cdir
	sed -e "${cdir:+#}/^Y/d" -e "s/^[XY]//" >"${T}/${SITEFILE}" <<-EOF || die
	X
	;;; ${EMACS_SUFFIX} site-lisp configuration
	X
	(when (string-match "\\\\\`${FULL_VERSION//./\\\\.}\\\\>" emacs-version)
	Y  (setq find-function-C-source-directory
	Y	"${EPREFIX}${cdir}")
	X  (let ((path (getenv "INFOPATH"))
	X	(dir "${EPREFIX}/usr/share/info/${EMACS_SUFFIX}")
	X	(re "\\\\\`${EPREFIX}/usr/share\\\\>"))
	X    (and path
	X	 ;; move Emacs Info dir before anything else in /usr/share
	X	 (let* ((p (cons nil (split-string path ":" t))) (q p))
	X	   (while (and (cdr q) (not (string-match re (cadr q))))
	X	     (setq q (cdr q)))
	X	   (setcdr q (cons dir (delete dir (cdr q))))
	X	   (setenv "INFOPATH" (mapconcat 'identity (cdr p) ":"))))))
	EOF
	elisp-site-file-install "${T}/${SITEFILE}" || die

	dodoc README BUGS CONTRIBUTE

	local DOC_CONTENTS="You can set the version to be started by
		/usr/bin/emacs through the Emacs eselect module, which also
		redirects man and info pages. Therefore, several Emacs versions can
		be installed at the same time. \"man emacs.eselect\" for details.
		\\n\\nIf you upgrade from a previous major version of Emacs, then
		it is strongly recommended that you use app-admin/emacs-updater
		to rebuild all byte-compiled elisp files of the installed Emacs
		packages."
	readme.gentoo_create_doc
}

pkg_preinst() {
	# verify that the PM hasn't removed our Info directory index #257260
	local infodir="${ED}/usr/share/info/${EMACS_SUFFIX}"
	[[ -f ${infodir}/dir || ! -d ${infodir} ]] || die
}

pkg_postinst() {
	elisp-site-regen
	readme.gentoo_print_elog

	eselect emacs update ifunset
}

pkg_postrm() {
	elisp-site-regen
	eselect emacs update ifunset
}
