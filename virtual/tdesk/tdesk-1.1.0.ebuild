# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="fcitx video -hyprland +sway full"

DEPEND=" (
  virtual/tcmd

  app-misc/jq
  app-text/aspell
  gnome-extra/nm-applet[appindicator]
  gui-apps/fnott
  gui-apps/foot
  gui-apps/fuzzel
  gui-apps/grim
  gui-apps/slurp
  gui-apps/swaybg[gdk-pixbuf]
  gui-apps/swayidle
  gui-apps/swaylock-effects
  gui-apps/waybar[tray,pipewire,experimental]
  gui-apps/wl-clipboard
  gui-apps/wob

  media-fonts/cascadia-code
  media-fonts/wqy-microhei
  media-fonts/nerd-fonts[nerdfontssymbolsonly]

  sys-fs/udisks
  sys-power/thermald
  sys-power/upower
  x11-libs/libnotify
  x11-misc/pcmanfm
  x11-themes/adwaita-qt
  x11-themes/faenza-icon-theme
  media-sound/pavucontrol

  dev-util/debugedit

  hyprland? (
  gui-wm/hyprland
  )

  sway? (
  gui-wm/sway
  gui-apps/autotiling
  gui-apps/swaynagmode
  )

  fcitx? (
  app-i18n/fcitx:5
  app-i18n/fcitx-configtool:5
  app-i18n/fcitx-gtk:5
  app-i18n/fcitx-qt:5
  app-i18n/fcitx-rime:5
  )

  video? (
  media-video/mpv
  net-misc/yt-dlp
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
