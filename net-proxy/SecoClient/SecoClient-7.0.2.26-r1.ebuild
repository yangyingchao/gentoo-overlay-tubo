EAPI=7
inherit gnome2-utils pax-utils myunpack xdg-utils

DESCRIPTION="SecoClient-7.0.2.26"
HOMEPAGE="HOMEPAGE"
SRC_URI="https://github.com/h2o8/secoclient/releases/download/7.0.2.26/secoclient-linux-64-7.0.2.26.run"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="strip mirror bindist"

DEPEND="
dev-qt/qtcore:5
dev-qt/qtdbus:5
dev-qt/qtgui:5
dev-qt/qtnetwork:5
dev-qt/qtwayland:5
dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}"
src_unpack() {
	mkdir -p /var/tmp/portage/net-proxy/${PF}/work/SecoClient
}

src_install() {
	dodir /
	cd "${ED}" || die

	# NOTE: secoclient reads KEYs from hardcoded path...
	dodir /usr/local/SecoClient/certificate
	pushd usr/local/SecoClient || die
	my_unpack "${DISTDIR}"/secoclient-linux-64-${PV}.run || die

	while IFS= read -r -d '' fn; do
		fperms -R 0755 "/usr/local/SecoClient/${fn}"
	done < <(find . -type d -print0)

	rm -rf lib plugins help
	dosym /usr/lib64/qt5/plugins/ /usr/local/SecoClient/plugins

	fperms a+x /usr/local/SecoClient/SecoClient
	fperms 777 /usr/local/SecoClient/SecoClient
	fperms u+s /usr/local/SecoClient/serviceclient/SecoClientCS

	insinto /usr/local/SecoClient/image/
	doins "${FILESDIR}"/SecoClient.png

	insinto /usr/share/applications
	doins "${FILESDIR}/SecoClient.desktop"

	exeinto /usr/bin/
	doexe "${FILESDIR}"/secoclient
}

pkg_postinst() {
	einfo "Beofre use, install your cetifications to: '/usr/local/SecoClient/certificat/'."
}
