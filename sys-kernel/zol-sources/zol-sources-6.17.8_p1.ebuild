# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# zol(zen or lqx) sources

# (yc/update-genpatch-version)

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="11"
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

# ZEN_TYPE="lqx"
ZEN_TYPE="zen"

if [[ "${ZEN_TYPE}" = zen ]]; then
	ZEN_PREFIX="linux-"
	ZEN_SUFFIX="zst"
	UNIPATCH_LIST="${WORKDIR}/${ZEN_PREFIX}v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}.patch"
	ZEN_URI="https://github.com/zen-kernel/zen-kernel/releases/download/v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}/${ZEN_PREFIX}v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}.patch.${ZEN_SUFFIX}"
else
	K_WANT_GENPATCHES=""
	ZEN_PREFIX=""
	ZEN_SUFFIX="xz"
	# https://github.com/zen-kernel/zen-kernel/releases/download/v6.17.5-lqx1/v6.17.5-lqx1.patch.xz
	UNIPATCH_LIST="${WORKDIR}/${ZEN_PREFIX}v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}.patch"
	ZEN_URI="https://github.com/zen-kernel/zen-kernel/releases/download/v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}/${ZEN_PREFIX}v${PATCH_VERSION}-${ZEN_TYPE}${PV#*p}.patch.${ZEN_SUFFIX}"
fi

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${ZEN_URI}"

UNIPATCH_STRICTORDER="yes"

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on oftc"

src_unpack() {
	unpacker "${ZEN_PREFIX}v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}.patch.${ZEN_SUFFIX}"
	kernel-2_src_unpack
}

pkg_setup() {
	kernel-2_pkg_setup
}

src_configure() {
	cd "${S}" || die
	local Z_CONFIG=${FILESDIR}/kernel-config-$(LANG=C lscpu | grep -i 'vendor' | awk -F ':' '{print $2}' | xargs)

	echo ""
	einfo "Install config..."
	cat "${Z_CONFIG}" > .config
	einfo "Done.. config file: $(realpath .config)..."
}

src_install() {
	rm "${WORKDIR}/${ZEN_PREFIX}v${FULL_VERSION}-${ZEN_TYPE}${PV#*p}.patch" || die
	kernel-2_src_install
}

pkg_postinst() {
	kernel-2_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
