# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit systemd

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"

DEPEND="(
	app-admin/stow
	app-arch/unrar
	app-portage/mirrorselect
	app-shells/zsh
	net-misc/networkmanager
	sys-apps/debianutils
	sys-kernel/installkernel
)"

src_unpack() {
	echo "Preparing fake dir: $P"
	mkdir "${P}" || die "failed to create dir."
}

src_install() {
	mkdir -p "${ED}"/etc/env.d || die "failed to create directory."
	cat <<- EOF > "${ED}"/etc/env.d/98kernel
		KCFLAGS="-O2 -march=native -pipe"
	EOF

	systemd_newunit "${FILESDIR}/user-service_at.service" user-service@.service

	exeinto /usr/lib/kernel/install.d/
	doexe "${FILESDIR}"/99-save-kernel-config.install
}
