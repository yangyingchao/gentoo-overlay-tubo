# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# (yc/update-genpatch-version)

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="12" # NOTE: update this based on gentoo-sources when updating zen-sources
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"

inherit kernel-2 unpacker
detect_version
detect_arch

KEYWORDS="amd64 ~arm64 ~x86"
HOMEPAGE="https://github.com/zen-kernel"
IUSE=""

SLOT="${PV%.*_*}"

# needed since patch is now zstd compressed
BDEPEND="$(unpacker_src_uri_depends)"

DESCRIPTION="The Zen Kernel Live Sources"

FULL_VERSION="${PV%_*}"
PATCH_VERSION=${FULL_VERSION%.*}
REVISION=${FULL_VERSION##*.}

if [[ "${REVISION}" != "0" ]]; then
	PATCH_VERSION="${PATCH_VERSION}.${REVISION}"
fi

ZEN_URI="https://github.com/zen-kernel/zen-kernel/releases/download/v${PATCH_VERSION}-zen${PV#*p}/linux-v${PATCH_VERSION}-zen${PV#*p}.patch.zst"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${ZEN_URI}"

UNIPATCH_LIST="${WORKDIR}/linux-v${PATCH_VERSION}-zen${PV#*p}.patch"
UNIPATCH_STRICTORDER="yes"

K_EXTRAEINFO="For more info on zen-sources, and for how to report problems, see: \
${HOMEPAGE}, also go to #zen-sources on oftc"

src_unpack() {
	unpacker "linux-v${PATCH_VERSION}-zen${PV#*p}.patch.zst"
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
	rm "${WORKDIR}/linux-v${PATCH_VERSION}-zen${PV#*p}.patch" || die
	kernel-2_src_install
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
