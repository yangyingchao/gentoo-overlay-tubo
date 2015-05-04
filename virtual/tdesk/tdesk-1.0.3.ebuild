# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="My desktop enviroment."
SLOT="1.7"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="wayland X"


DEPEND=" (
  media-fonts/wqy-microhei
  sys-apps/kmu
  sys-apps/the_silver_searcher
  sys-process/htop
  sys-apps/ripgrep
  app-shells/zsh
  sys-power/upower
  app-misc/jq
  app-arch/unrar

  wayland? (
  gui-wm/sway[-swaybar,swaybg,swayidle,-swaylock,swaymsg,swaynag,systemd,tray,zsh-completion]
  gui-apps/waybar[tray]
  gui-apps/swaylock-effects
  gui-apps/grim
  gui-apps/slurp
  gui-apps/mako
  gui-apps/wl-clipboard
  x11-misc/j4-dmenu-desktop
  dev-libs/bemenu
  xfce-base/thunar
  )

  X? (
  gnome-extra/nm-applet
  media-gfx/feh
  media-gfx/scrot
  x11-apps/xrandr
  x11-base/xorg-server
  x11-misc/dunst
  x11-misc/i3lock
  x11-misc/picom
  x11-misc/polybar
  x11-misc/slim
  x11-misc/wmctrl
  x11-misc/xdotool
  x11-misc/xss-lock
  x11-terms/rxvt-unicode
  x11-themes/adwaita-qt
  x11-wm/i3-gaps
  x11-misc/pcmanfm
  x11-misc/rofi
  )
)"

src_unpack() {
    echo "Preparing fake dir: $P"
    mkdir ${P} || die "failed to create dir."
}

src_install() {
    echo "SS: $S"
    mkdir -p ${ED}/etc/env.d || die "failed to create directory."
    cat <<EOF > ${ED}/etc/env.d/98theme
QT_STYLE_OVERRIDE=adwaita
EOF
}
