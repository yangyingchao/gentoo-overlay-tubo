# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="My desktop enviroment."
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="fcitx media fonts"

DEPEND=" (
  virtual/tcmd

  app-i18n/fcitx-meta:5
  app-i18n/librime
  app-i18n/librime-lua
  app-i18n/librime-octagram
  app-misc/jq
  app-text/aspell
  dev-util/debugedit
  gui-apps/foot
  gui-apps/grim
  gui-apps/noctalia
  gui-apps/qt6ct
  gui-apps/slurp
  gui-apps/wf-recorder
  gui-apps/wl-clipboard
  gui-apps/wl-mirror
  gui-apps/wlrctl
  gui-wm/umbriel
  media-fonts/noto-emoji
  media-fonts/noto[cjk,extra]
  media-gfx/chafa
  media-gfx/imagemagick
  media-gfx/imv
  media-sound/pavucontrol
  media-sound/playerctl
  media-video/ffmpeg[xvid]
  net-misc/yt-dlp
  sys-apps/dbus-broker
  sys-apps/usbutils
  sys-apps/xdg-desktop-portal-gnome
  sys-apps/xdg-desktop-portal-umbriel
  sys-auth/polkit[gtk]
  sys-fs/udisks
  sys-power/power-profiles-daemon
  sys-power/thermald
  sys-power/upower
  x11-misc/pcmanfm
  x11-themes/adw-gtk3
  x11-themes/adwaita-qt
  x11-themes/faenza-icon-theme

  app-office/wordcraft
  app-office/pdfcraft
  app-office/gridcraft
)"

src_unpack() {
	echo "Preparing fake dir: $P"
	mkdir ${P} || die "failed to create dir."
}

pkg_postinst() {
	echo "enable dbus-broker..."
	systemctl enable --global dbus-broker.service
	systemctl enable dbus-broker.service
}
