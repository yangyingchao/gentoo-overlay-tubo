# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="fcitx video full +niri -hyprland"

DEPEND=" (
  virtual/tcmd

  app-misc/brightnessctl
  app-misc/jq
  app-text/aspell
  dev-util/debugedit
  gnome-extra/nm-applet[appindicator]
  gui-apps/fnott
  gui-apps/foot
  gui-apps/fuzzel-x
  gui-apps/grim
  gui-apps/hypridle
  gui-apps/hyprlock
  gui-apps/hyprpaper
  gui-apps/hyprpicker
  gui-apps/slurp
  gui-apps/swayosd
  gui-apps/waybar[tray,pipewire,experimental]
  gui-apps/wl-clipboard
  gui-apps/wlrctl
  gui-libs/xdg-desktop-portal-hyprland
  gui-wm/hyprland
  media-sound/pavucontrol
  sys-auth/polkit[gtk]
  sys-fs/udisks
  sys-power/power-profiles-daemon
  sys-power/thermald
  sys-power/upower
  x11-libs/libnotify
  x11-misc/pcmanfm
  x11-themes/adwaita-qt
  x11-themes/faenza-icon-theme

  fcitx? (
  app-i18n/fcitx-meta:5
  app-i18n/librime
  app-i18n/librime-lua
  app-i18n/librime-octagram
  )

  video? (
  media-video/mpv
  media-gfx/imv
  media-gfx/imagemagick
  )

  full? (
  media-fonts/noto[cjk,extra]
  media-fonts/noto-emoji
  )
)"

src_unpack() {
	echo "Preparing fake dir: $P"
	mkdir ${P} || die "failed to create dir."
}

src_install() {
	mkdir -p ${ED}/etc/env.d || die "failed to create directory."
	cat <<EOF > ${ED}/etc/env.d/98theme
QT_STYLE_OVERRIDE=adwaita
EOF
}
