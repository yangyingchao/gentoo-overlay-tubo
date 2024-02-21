# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit systemd

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"

DEPEND=" (
  app-arch/unrar
  app-admin/stow
  app-shells/zsh
  sys-apps/fd
  sys-apps/ripgrep
  sys-process/htop
  net-misc/networkmanager
)"

src_unpack() {
	echo "Preparing fake dir: $P"
	mkdir ${P} || die "failed to create dir."
}

src_install() {
	mkdir -p ${ED}/etc/env.d || die "failed to create directory."
	cat <<-EOF > ${ED}/etc/env.d/98kernel
KCFLAGS="-O2 -march=native -pipe"
EOF

  systemd_newunit "${FILESDIR}/user-service_at.service" user-service@.service
}