# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="fcitx media fonts niri"

DEPEND=" (
  virtual/tcmd

  app-i18n/fcitx-meta:5
  app-i18n/librime
  app-i18n/librime-lua
  app-i18n/librime-octagram
  app-misc/brightnessctl
  app-misc/jq
  app-text/aspell
  dev-util/debugedit
  gnome-extra/nm-applet[appindicator]
  gui-apps/fnott
  gui-apps/foot
  gui-apps/fuzzel-x
  gui-apps/grim
  gui-apps/satty
  gui-apps/slurp
  gui-apps/swaybg
  gui-apps/swayidle
  gui-apps/swaylock-effects
  gui-apps/swayosd
  gui-apps/waybar[tray,pipewire,experimental]
  gui-apps/wf-recorder
  gui-apps/wl-clipboard
  gui-apps/wl-mirror
  gui-apps/wlrctl
  gui-apps/xwayland-satellite
  gui-wm/niri
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
  sys-auth/polkit[gtk]
  sys-fs/udisks
  sys-power/power-profiles-daemon
  sys-power/thermald
  sys-power/upower
  x11-libs/libnotify
  x11-misc/pcmanfm
  x11-themes/adwaita-qt
  x11-themes/faenza-icon-theme

)"

src_unpack() {
	echo "Preparing fake dir: $P"
	mkdir ${P} || die "failed to create dir."
}

src_install() {
	mkdir -p ${ED}/etc/env.d || die "failed to create directory."
	cat << EOF > ${ED}/etc/env.d/98theme
QT_STYLE_OVERRIDE=adwaita
EOF
}

pkg_postinst() {
	echo "enable dbus-broker..."
	systemctl enable --global dbus-broker.service
	systemctl enable dbus-broker.service
}
