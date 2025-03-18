# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# (yc/update-genpatch-version)

EAPI="8"
ETYPE="sources"
K_GENPATCHES_VER="20"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"

inherit kernel-2 unpacker
detect_version
detect_arch

KEYWORDS="amd64 ~arm64 ~x86"
HOMEPAGE="https://github.com/zen-kernel"
IUSE=""
SLOT="${PV%.*_*}"
BDEPEND="$(unpacker_src_uri_depends)"
DESCRIPTION="The Zen Kernel Live Sources"

FULL_VERSION="${PV%_*}"
PATCH_VERSION=${FULL_VERSION%.*}
REVISION=${FULL_VERSION##*.}

ZEN_TYPE="lqx" # or zen

if [[ "${ZEN_TYPE}" = "zen" ]]; then
	K_WANT_GENPATCHES="base extras"
	ZEN_PREFIX="linux-"
	ZEN_SUFFIX="zst"
else
	K_WANT_GENPATCHES=""
	ZEN_PREFIX=""
	ZEN_SUFFIX="xz"
fi

if [[ "${REVISION}" != "0" ]]; then
	PATCH_VERSION="${PATCH_VERSION}.${REVISION}"
fi

ZEN_URI="https://github.com/zen-kernel/zen-kernel/releases/download/v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}/${ZEN_PREFIX}v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}.patch.${ZEN_SUFFIX}"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${ZEN_URI}"

UNIPATCH_LIST="${WORKDIR}/${ZEN_PREFIX}v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}.patch"
UNIPATCH_STRICTORDER="yes"

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on oftc"

src_unpack() {
	unpacker "${ZEN_PREFIX}v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}.patch.${ZEN_SUFFIX}"
	kernel-2_src_unpack
}

pkg_setup() {
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the zen developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_install() {
	rm "${WORKDIR}/${ZEN_PREFIX}v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}.patch" || die
	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst

	local Z_CONFIG=${FILESDIR}/kernel-config-$(LANG=C lscpu | grep -i 'vendor' | awk -F ':' '{print $2}' | xargs)

	echo ""
	einfo "Install config..."
	if [[ -f "${EROOT}"/usr/src/linux/.config ]]; then
		cp -aRfv "${EROOT}"/usr/src/linux/.config "${EROOT}"/usr/src/linux/.config.bak
	fi

	cp -aRfv "${Z_CONFIG}" "${EROOT}"/usr/src/linux/.config

	echo ""
	ewarn "If you have vmware installed, issue following command:"
	ewarn "vmware-modconfig --console --install-all"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
